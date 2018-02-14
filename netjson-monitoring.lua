#!/usr/bin/env lua
-- retrieve monitoring information
-- and return it as NetJSON Output
ubus_lib = require('ubus')
cjson = require('cjson')

function cat(file)
    local f = assert(io.open(file, 'rb'))
    local content = f:read('*all')
    f:close()
    return content
end

ubus = ubus_lib.connect()
if not ubus then
    error('Failed to connect to ubusd')
end

-- collect wireless interface names
status = ubus:call('network.wireless', 'status', {})
netjson = {type='DeviceMonitoring', interfaces={}}

-- collect relevant wireless interface stats
-- (traffic and connected clients)
for radio_name, radio in pairs(status) do
    for i, interface in ipairs(radio.interfaces) do
        name = interface.ifname
        clients = ubus:call('hostapd.'..name, 'get_clients', {})
        rx_bytes = cat('/sys/class/net/wlan1/statistics/rx_bytes')
        tx_bytes = cat('/sys/class/net/wlan1/statistics/tx_bytes')
        table.insert(netjson.interfaces, {
            name = name,
            clients = clients.clients,
            statistics = {
                rx_bytes = tonumber(rx_bytes),
                tx_bytes = tonumber(tx_bytes)
            }
        })
    end
end

cjson = require('cjson')
print(cjson.encode(netjson))
