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
    }
}

-- collect device data
wireless_status = ubus:call('network.wireless', 'status', {})
network_status = ubus:call('network.device', 'status', {})
interfaces = {}

-- collect relevant wireless interface stats
-- (traffic and connected clients)
for radio_name, radio in pairs(wireless_status) do
    for i, interface in ipairs(radio.interfaces) do
        name = interface.ifname
        if name then
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
            if next(clients.clients) ~= nil then
              netjson_interface.wireless.clients = netjson_clients(clients.clients)
            end
            table.insert(interfaces, netjson_interface)
        end
    end
end

if next(interfaces) ~= nil then
    netjson.interfaces = interfaces
end

print(cjson.encode(netjson))
