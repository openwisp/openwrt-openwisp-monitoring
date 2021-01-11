#!/usr/bin/env lua
-- retrieve monitoring information
-- and return it as NetJSON Output
io = require('io')
ubus_lib = require('ubus')
cjson = require('cjson')
nixio = require('nixio')
uci = require('uci')
uci_cursor = uci.cursor()

-- split function
function split(str, pat)
    local t = {}
    local fpat = "(.-)" .. pat
    local last_end = 1
    local s, e, cap = str:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(t, cap)
        end
        last_end = e + 1
        s, e, cap = str:find(fpat, last_end)
    end
    if last_end <= #str then
        cap = str:sub(last_end)
        table.insert(t, cap)
    end
    return t
end

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

-- parse /proc/net/arp
function parse_arp()
    arp_info = {}
    for line in io.lines('/proc/net/arp 2> /dev/null') do
        if line:sub(1, 10) ~= 'IP address' then
            ip, hw, flags, mac, mask, dev = line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
            table.insert(arp_info, {
                ip = ip,
                mac = mac,
                interface = dev,
                state = ''
            })
        end
    end
    return arp_info
end

function get_ip_neigh_json()
    arp_info = {}
    output = io.popen('ip -json neigh 2> /dev/null'):read()
    if output ~= nil and pcall(function () json_output = cjson.decode(output) end) then
        json_output = cjson.decode(output)
        for _, arp_entry in pairs(json_output) do
            table.insert(arp_info, {
                ip = arp_entry["dst"],
                mac = arp_entry["lladdr"],
                interface = arp_entry["dev"],
                state = arp_entry["state"][1]
            })
        end
    end
    return arp_info
end

function get_ip_neigh()
    arp_info = {}
    output = io.popen('ip neigh 2> /dev/null')
    for line in output:lines() do
        ip, dev, mac, state = line:match("(%S+)%s+dev%s+(%S+)%s+lladdr%s+(%S+).*%s(%S+)")
        if mac ~= nil then
            table.insert(arp_info, {
                ip = ip,
                mac = mac,
                interface = dev,
                state = state
            })
        end
    end
    return arp_info
end

function get_neighbors()
    arp_table = get_ip_neigh_json()
    if next(arp_table) == nil then
        arp_table = get_ip_neigh()
    end
    if next(arp_table) == nil then
        arp_table = parse_arp()
    end
    return arp_table
end

function parse_dhcp_lease_file(path, leases)
    local f = io.open(path, 'r')
    if not f then
        return leases
    end

    for line in f:lines() do
        local expiry, mac, ip, name, id = line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
        table.insert(leases, {
            expiry = tonumber(expiry),
            mac = mac,
            ip = ip,
            client_name = name,
            client_id = id
        })
    end

    return leases
end

function get_dhcp_leases()
    local dhcp_configs = uci_cursor:get_all('dhcp')
    local leases = {}

    if not dhcp_configs or not next(dhcp_configs) then
        return nil
    end

    for name, config in pairs(dhcp_configs) do
        if config and config['.type'] == 'dnsmasq' and config.leasefile then
            leases = parse_dhcp_lease_file(config.leasefile, leases)
        end
    end
    return leases
end

function is_table_empty(table_)
    return not table_ or next(table_) == nil
end

function parse_hostapd_clients(clients)
  local data = {}
  for mac, properties in pairs(clients) do
      properties.mac = mac
      table.insert(data, properties)
  end
  return data
end

function parse_iwinfo_clients(clients)
  local data = {}
  for i, p in pairs(clients) do
      client = {}
      client.ht = p.rx.ht
      client.mac = p.mac
      client.authorized = p.authorized
      client.vht = p.rx.vht
      client.wmm = p.wme
      client.mfp = p.mfp
      client.auth = p.authenticated
      client.signal = p.signal
      client.noise = p.noise
      table.insert(data, client)
  end
  return data
end

-- takes ubus wireless.status clients output and converts it to NetJSON
function netjson_clients(clients, is_mesh)
    return (is_mesh and parse_iwinfo_clients(clients) or parse_hostapd_clients(clients))
end

ubus = ubus_lib.connect()
if not ubus then
    error('Failed to connect to ubusd')
end

-- helpers
iwinfo_modes = {
    ['Master'] = 'access_point',
    ['Client'] = 'station',
    ['Mesh Point'] = '802.11s',
    ['Ad-Hoc'] = 'adhoc'
}

-- collect system info
system_info = ubus:call('system', 'info', {})
board = ubus:call('system', 'board', {})
loadavg_output = io.popen('cat /proc/loadavg'):read()
loadavg_output = split(loadavg_output, ' ')
load_average = {tonumber(loadavg_output[1]), tonumber(loadavg_output[2]), tonumber(loadavg_output[3])}

function parse_disk_usage()
    file = io.popen('df')
    disk_usage_info = {}
    for line in file:lines() do
        if line:sub(1, 10) ~= 'Filesystem' then
            filesystem, size, used, available, percent, location =
                line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
            if filesystem ~= 'tmpfs' and not string.match(filesystem, 'overlayfs') then
                percent = percent:gsub('%W', '')
                -- available, size and used are in KiB
                table.insert(disk_usage_info, {
                    filesystem = filesystem,
                    available_bytes = tonumber(available) * 1024,
                    size_bytes = tonumber(size) * 1024,
                    used_bytes = tonumber(used) * 1024,
                    used_percent = tonumber(percent),
                    mount_point = location
                })
            end
        end
    end
    file:close()
    return disk_usage_info
end

function get_cpus()
    processors = io.popen('cat /proc/cpuinfo | grep -c processor')
    cpus = tonumber(processors:read('*a'))
    processors:close()
    return cpus
end

function get_vpn_interfaces()
    -- only openvpn supported for now
    local items = uci_cursor:get_all('openvpn')
    local vpn_interfaces = {}

    if is_table_empty(items) then
        return {}
    end

    for name, config in pairs(items) do
        if config and config.dev then
            vpn_interfaces[config.dev] = true
        end
    end
    return vpn_interfaces
end

-- init netjson data structure
netjson = {
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
        cpus = get_cpus(),
        disk = parse_disk_usage()
    }
}

dhcp_leases = get_dhcp_leases()
if not is_table_empty(dhcp_leases) then
    netjson.dhcp_leases = dhcp_leases
end

neighbors = get_neighbors()
if not is_table_empty(neighbors) then
    netjson.neighbors = neighbors
end

-- determine the interfaces to monitor
traffic_monitored = arg[1]
include_stats = {}
if traffic_monitored then
    traffic_monitored = split(traffic_monitored, ' ')
    for i, name in pairs(traffic_monitored) do
        include_stats[name] = true
    end
end

function is_excluded(name)
    return name == 'lo'
end

function find_default_gateway(routes)
    for i = 1, #routes do
        if routes[i].target == '0.0.0.0' then
            return routes[i].nexthop
        end
    end
    return nil
end

-- collect device data
network_status = ubus:call('network.device', 'status', {})
wireless_status = ubus:call('network.wireless', 'status', {})
interface_data = ubus:call('network.interface', 'dump', {})
nixio_data = nixio.getifaddrs()
vpn_interfaces = get_vpn_interfaces()
wireless_interfaces = {}
interfaces = {}
dns_servers = {}
dns_search = {}

function new_address_array(address, interface, family)
    proto = interface['proto']
    if proto == 'dhcpv6' then
        proto = 'dhcp'
    end
    new_address = {
        address = address['address'],
        mask = address['mask'],
        proto = proto,
        family = family,
        gateway = find_default_gateway(interface.route)
    }
    return new_address
end

function get_interface_info(name, netjson_interface)
    info = {
        dns_search = nil,
        dns_servers = nil
    }
    for _, interface in pairs(interface_data['interface']) do
        if interface['l3_device'] == name then
            if next(interface['dns-search']) then
                info.dns_search = interface['dns-search']
            end
            if next(interface['dns-server']) then
                info.dns_servers = interface['dns-server']
            end
            if netjson_interface.type == 'bridge' then
                info.stp = uci_cursor.get('network', interface['interface'], 'stp') == '1'
            end
        end
    end
    return info
end

function array_concat(source, destination)
    table.foreach(source, function(key, value)
        table.insert(destination, value)
    end)
end

function dict_merge(source, destination)
    table.foreach(source, function(key, value)
        destination[key] = value
    end)
end

-- collect interface addresses
function get_addresses(name)
    addresses = {}
    interface_list = interface_data['interface']
    addresses_list = {}
    for _, interface in pairs(interface_list) do
        if interface['l3_device'] == name then
            proto = interface['proto']
            if proto == 'dhcpv6' then
                proto = 'dhcp'
            end
            for _, address in pairs(interface['ipv4-address']) do
                table.insert(addresses_list, address['address'])
                new_address = new_address_array(address, interface, 'ipv4')
                table.insert(addresses, new_address)
            end
            for _, address in pairs(interface['ipv6-address']) do
                table.insert(addresses_list, address['address'])
                new_address = new_address_array(address, interface, 'ipv6')
                table.insert(addresses, new_address)
            end
        end
    end
    for i = 1, #nixio_data do
        if nixio_data[i].name == name then
            if not is_excluded(name) then
                family = nixio_data[i].family
                addr = nixio_data[i].addr
                if family == 'inet' then
                    family = 'ipv4'
                    -- Since we don't already know this from the dump, we can
                    -- consider this dynamically assigned, this is the case for
                    -- example for OpenVPN interfaces, which get their address
                    -- from the DHCP server embedded in OpenVPN
                    proto = 'dhcp'
                elseif family == 'inet6' then
                    family = 'ipv6'
                    if starts_with(addr, 'fe80') then
                        proto = 'static'
                    else
                        ula = uci_cursor.get('network', 'globals', 'ula_prefix')
                        ula_prefix = split(ula, '::')[1]
                        if starts_with(addr, ula_prefix) then
                            proto = 'static'
                        else
                            proto = 'dhcp'
                        end
                    end
                end
                if family == 'ipv4' or family == 'ipv6' then
                    if not has_value(addresses_list, addr) then
                        table.insert(addresses, {
                            address = addr,
                            mask = nixio_data[i].prefix,
                            proto = proto,
                            family = family
                        })
                    end
                end
            end
        end
    end
    return addresses
end

-- collect relevant wireless interface stats
-- (traffic and connected clients)
for radio_name, radio in pairs(wireless_status) do
    for i, interface in ipairs(radio.interfaces) do
        name = interface.ifname
        local is_mesh = false
        if name and not is_excluded(name) then
            iwinfo = ubus:call('iwinfo', 'info', {
                device = name
            })
            netjson_interface = {
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
              clients = ubus:call('hostapd.' .. name, 'get_clients', {}).clients
            end
            if clients and next(clients) ~= nil then
                netjson_interface.wireless.clients = netjson_clients(clients, is_mesh)
            end
            wireless_interfaces[name] = netjson_interface
        end
    end
end

-- collect interface stats
for name, interface in pairs(network_status) do
    -- only collect data from iterfaces which have not been excluded
    if not is_excluded(name) then
        netjson_interface = {
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
            dict_merge(wireless_interfaces[name], netjson_interface)
            interface.type = netjson_interface.type
        end
        if interface.type == 'Network device' then
            link_supported = interface['link-supported']
            if link_supported and next(link_supported) then
                netjson_interface.type = 'ethernet'
                netjson_interface.link_supported = link_supported
            elseif vpn_interfaces[name] then
                netjson_interface.type = 'virtual'
            else
                netjson_interface.type = 'other'
            end
        end
        if include_stats[name] then
            netjson_interface.statistics = interface.statistics
        end
        addresses = get_addresses(name)
        if next(addresses) then
            netjson_interface.addresses = addresses
        end
        info = get_interface_info(name, netjson_interface)
        if info.stp ~= nil then
            netjson_interface.stp = info.stp
        end
        table.insert(interfaces, netjson_interface)
        -- DNS info is independent from interface
        if info.dns_servers then
            array_concat(info.dns_servers, dns_servers)
        end
        if info.dns_search then
            array_concat(info.dns_search, dns_search)
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
