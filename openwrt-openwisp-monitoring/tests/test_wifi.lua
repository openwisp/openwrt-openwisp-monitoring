package.path = package.path .. ";../files/lib/openwisp/?.lua"

local wifi_data = require('test_files/wireless_data')

local luaunit = require('luaunit')
local wifi_functions = require('wifi')

TestWifi = {
    setUp = function()
    end,
    tearDown = function()
    end
}


function TestWifi.test_parse_hostapd_clients()
    luaunit.assertEquals(wifi_functions.parse_hostapd_clients(wifi_data.wlan1_clients), wifi_data.parsed_clients)
    luaunit.assertEquals(wifi_functions.parse_hostapd_clients(wifi_data.wlan0_clients), {})
end

function TestWifi.test_netjson_clients()
    luaunit.assertEquals(wifi_functions.netjson_clients(wifi_data.wlan1_clients, false), wifi_data.parsed_clients)
    luaunit.assertEquals(wifi_functions.netjson_clients(wifi_data.wlan0_clients, false), {})
end


os.exit( luaunit.LuaUnit.run() )
