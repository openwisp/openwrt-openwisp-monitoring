#!/usr/bin/env lua
-- retrieve monitoring information
-- and return it as NetJSON Output
local cjson = require('cjson')

local ubus_lib = require('ubus')
local ubus = ubus_lib.connect()
if not ubus then
    error('Failed to connect to ubusd')
end

local dhcp = require('dhcp')
local interface_functions = require('interfaces')
local neighbors_functions = require('neighbors')
local resources = require('resources')
local utils = require('utils')
local wifi = require('wifi')

-- helpers
local iwinfo_modes = {
    ['Master'] = 'access_point',
    ['Client'] = 'station',
    ['Mesh Point'] = '802.11s',
    ['Ad-Hoc'] = 'adhoc'
}

-- collect system info
local system_info = ubus:call('system', 'info', {})
local board = ubus:call('system', 'board', {})
local loadavg_output = io.popen('cat /proc/loadavg'):read()
loadavg_output = utils.split(loadavg_output, ' ')
local load_average = {tonumber(loadavg_output[1]), tonumber(loadavg_output[2]), tonumber(loadavg_output[3])}


-- init netjson data structure
local netjson = {
    type = 'DeviceMonitoring',
    general = {
        hostname = board.hostname,
        local_time = system_info.localtime,
        uptime = system_info.uptime
    },
    resources = {
        load = load_average,
        memory = system_info.memory,
        swap = system_info.swap,
        cpus = resources.get_cpus(),
        disk = resources.parse_disk_usage()
    }
}

local dhcp_leases = dhcp.get_dhcp_leases()
if not utils.is_table_empty(dhcp_leases) then
    netjson.dhcp_leases = dhcp_leases
end

local neighbors = neighbors_functions.get_neighbors()
if not utils.is_table_empty(neighbors) then
    netjson.neighbors = neighbors
end

-- determine the interfaces to monitor
local traffic_monitored = arg[1]
local include_stats = {}
if traffic_monitored and traffic_monitored ~= '*' then
    traffic_monitored = utils.split(traffic_monitored, ' ')
    for _, name in pairs(traffic_monitored) do
        include_stats[name] = true
    end
end

-- collect device data
local network_status = ubus:call('network.device', 'status', {})
local wireless_status = ubus:call('network.wireless', 'status', {})
local vpn_interfaces = interface_functions.get_vpn_interfaces()
local wireless_interfaces = {}
local interfaces = {}
local dns_servers = {}
local dns_search = {}


-- collect relevant wireless interface stats
-- (traffic and connected clients)
for _, radio in pairs(wireless_status) do
    for _, interface in ipairs(radio.interfaces) do
        local name = interface.ifname
        local is_mesh = false
        local clients = nil
        if name and not utils.is_excluded(name) then
            local iwinfo = ubus:call('iwinfo', 'info', {
                device = name
            })
            local netjson_interface = {
                name = name,
                type = 'wireless',
                wireless = {
                    ssid = iwinfo.ssid,
                    mode = iwinfo_modes[iwinfo.mode] or iwinfo.mode,
                    channel = iwinfo.channel,
                    frequency = iwinfo.frequency,
                    tx_power = iwinfo.txpower,
                    signal = iwinfo.signal,
                    noise = iwinfo.noise,
                    country = iwinfo.country
                }
            }
            if iwinfo.mode == 'Ad-Hoc' or iwinfo.mode == 'Mesh Point' then
                clients = ubus:call('iwinfo', 'assoclist', {
                    device = name
                }).results
                is_mesh = true
            else
              local hostapd_output = ubus:call('hostapd.' .. name, 'get_clients', {})
              if hostapd_output then
                  clients = hostapd_output.clients
              end
            end
            if not utils.is_table_empty(clients) then
                netjson_interface.wireless.clients = wifi.netjson_clients(clients, is_mesh)
            end
            wireless_interfaces[name] = netjson_interface
        end
    end
end

local function needs_inversion(interface)
    return interface.type == 'wireless' and interface.wireless.mode == 'access_point'
end

local function invert_rx_tx(interface)
    for k, v in pairs(interface) do
        if string.sub(k, 0, 3) == "rx_" then
            local tx_key = "tx_" .. string.sub(k, 4)
            local tx_val = interface[tx_key]
            interface[tx_key] = v
            interface[k] = tx_val
        end
    end
    return interface
end

-- collect interface stats
for name, interface in pairs(network_status) do
    -- only collect data from iterfaces which have not been excluded
    if not utils.is_excluded(name) then
        local netjson_interface = {
            name = name,
            type = string.lower(interface.type),
            up = interface.up,
            mac = interface.macaddr,
            txqueuelen = interface.txqueuelen,
            mtu = interface.mtu,
            speed = interface.speed,
            bridge_members = interface['bridge-members'],
            multicast = interface.multicast
        }
        if wireless_interfaces[name] then
            utils.dict_merge(wireless_interfaces[name], netjson_interface)
            interface.type = netjson_interface.type
        end
        if interface.type == 'Network device' then
            local link_supported = interface['link-supported']
            if link_supported and next(link_supported) then
                netjson_interface.type = 'ethernet'
                netjson_interface.link_supported = link_supported
            elseif vpn_interfaces[name] then
                netjson_interface.type = 'virtual'
            else
                netjson_interface.type = 'other'
            end
        end
        if include_stats[name] or traffic_monitored == '*' then
            if needs_inversion(netjson_interface) then
                --- ensure wifi access point interfaces
                --- show download and upload values from
                --- the user's perspective and not from the router perspective
                interface.statistics = invert_rx_tx(interface.statistics)
            end
            netjson_interface.statistics = interface.statistics
        end
        local addresses = interface_functions.get_addresses(name)
        if next(addresses) then
            netjson_interface.addresses = addresses
        end
        local info = interface_functions.get_interface_info(name, netjson_interface)
        if info.stp ~= nil then
            netjson_interface.stp = info.stp
        end
        if info.specialized then
            for key, value in pairs(info.specialized) do
                netjson_interface[key] = value
            end
        end
        table.insert(interfaces, netjson_interface)
        -- DNS info is independent from interface
        if info.dns_servers then
            utils.array_concat(info.dns_servers, dns_servers)
        end
        if info.dns_search then
            utils.array_concat(info.dns_search, dns_search)
        end
    end
end

if next(interfaces) ~= nil then
    netjson.interfaces = interfaces
end
if next(dns_servers) ~= nil then
    netjson.dns_servers = dns_servers
end
if next(dns_search) ~= nil then
    netjson.dns_search = dns_search
end

print(cjson.encode(netjson))
