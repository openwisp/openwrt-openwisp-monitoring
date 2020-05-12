#!/usr/bin/env lua
-- retrieve monitoring information
-- and return it as NetJSON Output
io = require('io')
ubus_lib = require('ubus')
cjson = require('cjson')

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
        swap = system_info.swap
    },
    neighbors = get_neighbors()
}

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
    table.insert(interfaces, netjson_interface)
  end
end

if next(interfaces) ~= nil then
    netjson.interfaces = interfaces
end

print(cjson.encode(netjson))
