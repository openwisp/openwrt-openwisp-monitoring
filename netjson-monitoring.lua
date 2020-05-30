#!/usr/bin/env lua
-- retrieve monitoring information
-- and return it as NetJSON Output
io = require('io')
ubus_lib = require('ubus')
cjson = require('cjson')
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
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

-- parse /proc/net/arp
function parse_arp()
   arp_info = {}
   for line in io.lines('/proc/net/arp 2> /dev/null') do
      if line:sub(1, 10) ~= 'IP address' then
        ip, hw, flags, mac, mask, dev = line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
        table.insert(arp_info, {
            ip_address = ip,
            mac_address = mac,
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
   if output ~= nil then
      json_output = cjson.decode(output)
      for _, arp_entry in pairs(json_output) do
         table.insert(arp_info, {
           ip_address = arp_entry["dst"],
           mac_address = arp_entry["lladdr"],
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
          ip_address = ip,
          mac_address = mac,
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
            mac_address = mac,
            ip_address = ip,
            client_name = name,
            client_id = id
         })
    end

    return leases
end

function get_dhcp_leases()
    local uci_cursor = uci.cursor()
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

-- takes ubus wireless.status clients output and converts it to NetJSON
function netjson_clients(clients)
    local data = {}
    for mac_address, properties in pairs(clients) do
        properties.mac = mac_address
        table.insert(data, properties)
    end
    return data
end

ubus = ubus_lib.connect()
if not ubus then
    error('Failed to connect to ubusd')
end

-- helpers
iwinfo_modes = {
    ['Master'] = 'access_point',
    ['Client']= 'station',
    ['Mesh Point'] = '802.11s',
    ['Ad-Hoc'] = 'adhoc'
}

-- collect system info
system_info = ubus:call('system', 'info', {})
board = ubus:call('system', 'board', {})
loadavg_output = io.popen('cat /proc/loadavg'):read()
loadavg_output = split(loadavg_output, ' ')
load_average = {tonumber(loadavg_output[1]),
                tonumber(loadavg_output[2]),
                tonumber(loadavg_output[3])}

function parse_disk_usage()
    file = io.popen('df')
    disk_usage_info = {}
    for line in file:lines() do
        if line:sub(1, 10) ~= 'Filesystem' then
            filesystem, size, used, available, percent, location = line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
            if filesystem ~= 'tmpfs' and not string.match(filesystem, 'overlayfs') then
                percent = percent:gsub('%W', '')
                table.insert(disk_usage_info, {
                    filesystem = filesystem,
                    available_bytes = tonumber(available),
                    size_bytes = tonumber(size),
                    used_bytes = tonumber(used),
                    used_percent = tonumber(percent),
                    mount_point = location,
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
if next(dhcp_leases) then
    netjson.dhcp_leases = dhcp_leases
end

neighbors = get_neighbors()
if next(neighbors) then
    netjson.neighbors = neighbors
end

-- determine the interfaces to monitor
included_interfaces = arg[1]
included = {}
if included_interfaces then
  included_interfaces = split(included_interfaces, ' ')
  for i, name in pairs(included_interfaces) do
    included[name] = true
  end
end

function is_excluded(name)
  if next(included) ~= nil then
    return included[name] == nil
  -- if list of included interfaces is empty
  -- consider all interfaces incldued
  else
    return name == 'lo'
  end
end

-- collect interface addresses
function get_addresses(name)
    interface_data = ubus:call('network.interface', 'dump', {})
    addresses = {}
    interface_list = interface_data['interface']
    for _, interface in pairs(interface_list) do
        if interface['l3_device'] == name then
            proto = interface['proto']
            for _, address in pairs(interface['ipv4-address']) do
                if proto == 'dhcpv6' then
                    proto = 'dhcp'
                end
                table.insert(addresses, {
                    address = address['address'],
                    mask = address['mask'],
                    proto = proto,
                    family = 'ipv4'
                })
            end
            for _, address in pairs(interface['ipv6-address']) do
                if proto == 'dhcpv6' then
                    proto = 'dhcp'
                end
                table.insert(addresses, {
                    address = address['address'],
                    mask = address['mask'],
                    proto = proto,
                    family = 'ipv6'
                })
            end
        end
    end
    return addresses
end

-- collect device data
network_status = ubus:call('network.device', 'status', {})
wireless_status = ubus:call('network.wireless', 'status', {})

interfaces = {}
processed = {}

-- collect relevant wireless interface stats
-- (traffic and connected clients)
for radio_name, radio in pairs(wireless_status) do
    for i, interface in ipairs(radio.interfaces) do
        name = interface.ifname
        if name and not is_excluded(name) then
            clients = ubus:call('hostapd.'..name, 'get_clients', {})
            iwinfo = ubus:call('iwinfo', 'info', {device = name})
            netjson_interface = {
                name = name,
                statistics = network_status[name].statistics,
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
            addresses = get_addresses(name)
            if next(addresses) ~= nil then
              netjson_interface.addresses = addresses
            end
            if clients and next(clients.clients) ~= nil then
              netjson_interface.wireless.clients = netjson_clients(clients.clients)
            end
            table.insert(interfaces, netjson_interface)
            -- avoid duplicating interface info
            processed[name] = true
        end
    end
end

-- collect interface stats
for name, interface in pairs(network_status) do
  -- only collect data from iterfaces which have not been excluded
  if not is_excluded(name) and not processed[name] then
    netjson_interface = {
        name = name,
        statistics = interface.statistics
    }
    addresses = get_addresses(name)
    if next(addresses) ~= nil then
        netjson_interface.addresses = addresses
    end
    table.insert(interfaces, netjson_interface)
  end
end

if next(interfaces) ~= nil then
    netjson.interfaces = interfaces
end

print(cjson.encode(netjson))
