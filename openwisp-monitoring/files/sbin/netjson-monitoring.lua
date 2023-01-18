#!/usr/bin/env lua

-- retrieve monitoring information
-- and return it as NetJSON Output
package.path = package.path .. ";../files/lib/?.lua"

local cjson = require('cjson')
local io = require('io')

local ubus_lib = require('ubus')
local ubus = ubus_lib.connect()
if not ubus then error('Failed to connect to ubusd') end

local monitoring = require('openwisp-monitoring.monitoring')

-- collect system info
local system_info = ubus:call('system', 'info', {})
local board = ubus:call('system', 'board', {})
local loadavg_file = io.popen('cat /proc/loadavg')
local loadavg_output = loadavg_file:read()
loadavg_file:close()
loadavg_output = monitoring.utils.split(loadavg_output, ' ')
local load_average = {
  tonumber(loadavg_output[1]), tonumber(loadavg_output[2]),
  tonumber(loadavg_output[3])
}

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
    cpus = monitoring.resources.get_cpus(),
    disk = monitoring.resources.parse_disk_usage()
  }
}

local dhcp_leases = monitoring.dhcp.get_dhcp_leases()
if not monitoring.utils.is_table_empty(dhcp_leases) then
  netjson.dhcp_leases = dhcp_leases
end

local host_neighbors = monitoring.neighbors.get_neighbors()
if not monitoring.utils.is_table_empty(host_neighbors) then
  netjson.neighbors = host_neighbors
end

-- determine the interfaces to monitor
local arg = {...}
local traffic_monitored = arg[1]
local include_stats = {}
if traffic_monitored and traffic_monitored ~= '*' then
  traffic_monitored = monitoring.utils.split(traffic_monitored, ' ')
  for _, name in pairs(traffic_monitored) do include_stats[name] = true end
end

-- collect device data
local network_status = ubus:call('network.device', 'status', {})
local wireless_status = ubus:call('network.wireless', 'status', {})
local vpn_interfaces = monitoring.interfaces.get_vpn_interfaces()
local wireless_interfaces = {}
local host_interfaces = {}
local dns_servers = {}
local dns_search = {}

local function get_wireless_netjson_interface(radio, name, iwinfo)
  local clients = nil
  local is_mesh = false
  local htmode = radio.config.htmode
  local netjson_interface = {
    name = name,
    type = 'wireless',
  }
  -- if channel is missing the WiFi interface is not fully up
  -- and hence we avoid including its info because it will be rejected
  if monitoring.utils.is_empty(iwinfo.channel) == false then
    netjson_interface.wireless = {
      ssid = iwinfo.ssid,
      mode = monitoring.wifi.iwinfo_modes[iwinfo.mode] or iwinfo.mode,
      channel = iwinfo.channel,
      frequency = iwinfo.frequency,
      tx_power = iwinfo.txpower,
      signal = iwinfo.signal,
      noise = iwinfo.noise,
      country = iwinfo.country,
      htmode = htmode
    }
    if iwinfo.mode == 'Ad-Hoc' or iwinfo.mode == 'Mesh Point' then
      clients = ubus:call('iwinfo', 'assoclist', {device = name}).results
      is_mesh = true
    else
      local hostapd_output = ubus:call('hostapd.' .. name, 'get_clients', {})
      if hostapd_output then clients = hostapd_output.clients end
    end
    if not monitoring.utils.is_table_empty(clients) then
      netjson_interface.wireless.clients = monitoring.wifi.netjson_clients(clients,
        is_mesh)
    end
  end
  return netjson_interface
end

-- collect relevant wireless interface stats
-- (traffic and connected clients)
for _, radio in pairs(wireless_status) do
  for _, interface in ipairs(radio.interfaces) do
    local name = interface.ifname
    if name and not monitoring.utils.is_excluded(name) then
      local iwinfo = ubus:call('iwinfo', 'info', {device = name})
      wireless_interfaces[name] = get_wireless_netjson_interface(radio, name, iwinfo)
    end
  end
end

-- collect interface stats
for name, interface in pairs(network_status) do
  -- only collect data from iterfaces which have not been excluded
  if not monitoring.utils.is_excluded(name) then
    local netjson_interface = {
      name = name,
      type = string.lower(interface.type),
      up = interface.up,
      mac = interface.macaddr,
      txqueuelen = interface.txqueuelen,
      mtu = interface.mtu,
      speed = interface.speed,
      multicast = interface.multicast
    }

    -- add existing bridge members only
    if interface['bridge-members'] ~= nil then
      local bridge_members = {}
      for _, bridge_member in ipairs(interface['bridge-members']) do
        if network_status[bridge_member] then
          local network_interface = network_status[bridge_member]
          if network_interface.up and network_interface.present then
            table.insert(bridge_members, bridge_member)
          end
        end
      end
      if next(bridge_members) ~= nil then
        netjson_interface['bridge_members'] = bridge_members
      end
    end
    if wireless_interfaces[name] then
      monitoring.utils.dict_merge(wireless_interfaces[name], netjson_interface)
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
      if monitoring.wifi.needs_inversion(netjson_interface) then
        --- ensure wifi access point interfaces
        --- show download and upload values from
        --- the user's perspective and not from the router perspective
        interface.statistics = monitoring.wifi.invert_rx_tx(interface.statistics)
      end
      netjson_interface.statistics = interface.statistics
    end
    local addresses = monitoring.interfaces.get_addresses(name)
    local virtual_interfaces = {'wireguard'}

    if next(addresses) and
      monitoring.utils.has_value(virtual_interfaces, addresses[1].proto) then
      netjson_interface.type = 'virtual'
    end
    if next(addresses) then netjson_interface.addresses = addresses end
    local info = monitoring.interfaces.get_interface_info(name, netjson_interface)
    if info.stp ~= nil then netjson_interface.stp = info.stp end
    if info.specialized then
      for key, value in pairs(info.specialized) do netjson_interface[key] = value end
    end
    table.insert(host_interfaces, netjson_interface)
    -- DNS info is independent from interface
    if info.dns_servers then
      monitoring.utils.array_concat(info.dns_servers, dns_servers)
    end
    if info.dns_search then
      monitoring.utils.array_concat(info.dns_search, dns_search)
    end
  end
end

if next(host_interfaces) ~= nil then netjson.interfaces = host_interfaces end
if next(dns_servers) ~= nil then netjson.dns_servers = dns_servers end
if next(dns_search) ~= nil then netjson.dns_search = dns_search end

io.write(cjson.encode(netjson))
return cjson.encode(netjson)
