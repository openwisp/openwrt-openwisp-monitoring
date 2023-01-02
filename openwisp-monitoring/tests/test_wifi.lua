package.path = package.path ..
                 ";../files/lib/openwisp-monitoring/?.lua;../files/sbin/?.lua"

local cjson = require("cjson")
local luaunit = require('luaunit')
local wifi_functions = require('wifi')
local wifi_data = require('test_files/wireless_data')

local function string_count(base, pattern)
  return select(2, string.gsub(base, pattern, ""))
end

TestWifi = {setUp = function() end, tearDown = function() end}

TestNetJSON = {
  setUp = function()
    local env = require('basic_env')
    package.loaded.io = env.io
    package.loaded.uci = env.uci
    package.loaded.ubus = {
      connect = function()
        return {
          call = function(...)
            local arg = {...}
            if arg[2] == 'system' and arg[3] == 'board' then
              return {hostname = "08-00-27-56-92-F5"}
            elseif arg[2] == 'system' and arg[3] == 'info' then
              return {memory = nil, local_time = nil, uptime = nil, swap = nil}
            elseif arg[2] == 'network.device' and arg[3] == 'status' then
              return require('test_files/network_data').wireless
            elseif arg[2] == 'network.wireless' and arg[3] == 'status' then
              return wifi_data.wireless_status
            elseif arg[2] == 'network.interface' and arg[3] == 'dump' then
              local f = require('test_files/interface_data')
              return f.interface_data
            elseif arg[2] == 'iwinfo' and arg[3] == 'info' then
              if arg[4].device == "wlan0" then
                return wifi_data.wlan0_iwinfo
              elseif arg[4].device == "wlan1" then
                return wifi_data.wlan1_iwinfo
              elseif arg[4].device == "wlan2" then
                return wifi_data.wlan2_iwinfo
              elseif arg[4].device == "mesh0" then
                return wifi_data.mesh0_iwinfo
              elseif arg[4].device == "mesh1" then
                return wifi_data.mesh1_iwinfo
              end
            elseif arg[2] == 'iwinfo' and arg[3] == 'assoclist' then
              if arg[4].device == "mesh0" then
                return wifi_data.mesh0_clients
              elseif arg[4].device == "mesh1" then
                return wifi_data.mesh1_clients
              end
            else
              return {}
            end
          end
        }
      end
    }
  end,
  tearDown = function() end
}

function TestWifi.test_parse_hostapd_clients()
  luaunit.assertEquals(wifi_functions.parse_hostapd_clients(wifi_data.wlan1_clients),
    wifi_data.parsed_clients)
  luaunit.assertEquals(wifi_functions.parse_hostapd_clients(wifi_data.wlan0_clients),
    {})
end

function TestWifi.test_parse_iwinfo_clients()
  luaunit.assertEquals(wifi_functions.parse_iwinfo_clients(
    wifi_data.mesh0_clients.results), wifi_data.mesh0_parsed_clients)
  luaunit.assertEquals(wifi_functions.parse_iwinfo_clients(
    wifi_data.mesh1_clients.results), wifi_data.mesh1_parsed_clients)
end

function TestWifi.test_netjson_clients()
  -- testing hostapd clients
  luaunit.assertEquals(wifi_functions.netjson_clients(wifi_data.wlan1_clients, false),
    wifi_data.parsed_clients)
  luaunit.assertEquals(wifi_functions.netjson_clients(wifi_data.wlan0_clients, false),
    {})
  -- testing iwinfo clients
  luaunit.assertEquals(
    wifi_functions.netjson_clients(wifi_data.mesh0_clients.results, true),
    wifi_data.mesh0_parsed_clients)
  luaunit.assertEquals(
    wifi_functions.netjson_clients(wifi_data.mesh1_clients.results, true),
    wifi_data.mesh1_parsed_clients)
end

function TestWifi.test_needs_inversion()
  luaunit.assertFalse(wifi_functions.needs_inversion(wifi_data.wlan0_interface))
  luaunit.assertTrue(wifi_functions.needs_inversion(wifi_data.wlan1_interface))
end

function TestWifi.test_invert_rx_tx()
  local network_data = require('test_files/network_data')
  luaunit.assertNotNil(network_data)
  local interface = wifi_functions.invert_rx_tx(network_data.wlan1_stats)
  luaunit.assertEquals(interface.rx_bytes, 531596854)
  luaunit.assertEquals(interface.tx_bytes, 0)
  luaunit.assertEquals(interface.rx_packets, 2367515)
  luaunit.assertEquals(interface.tx_packets, 0)
end

function TestNetJSON.test_wifi_interfaces()
  local netjson = require('netjson-monitoring')
  luaunit.assertNotNil(string.find(netjson, '"signal":-67', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"signal":-76', 1, true))
  luaunit.assertEquals(string_count(netjson, '"ssid":"meshID"'), 2)
  luaunit.assertEquals(string_count(netjson, '"tx_power":20'), 4)
  luaunit.assertEquals(string_count(netjson, '"vht":true'), 1)
  luaunit.assertEquals(string_count(netjson, '"vht":false'), 1)
  luaunit.assertEquals(string_count(netjson, '"tx_power":20'), 4)
  luaunit.assertEquals(string_count(netjson, '"frequency":5200'), 1)
  luaunit.assertEquals(string_count(netjson, '"mode":"access_point"'), 1)
end

function TestNetJSON.test_wifi_interfaces_stats_include()
  local netjson_file = assert(loadfile('../files/sbin/netjson-monitoring.lua'))
  local netjson = netjson_file('wlan0 wlan1 mesh1')
  luaunit.assertNotNil(string.find(netjson, '"channel":40', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"mode":"802.11s"', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"rx_packets":198', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"rx_packets":2367515', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"rx_bytes":25967', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"tx_bytes":531641723', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"tx_bytes":151599685066', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"tx_packets":2367747', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"tx_packets":2367747', 1, true))
  luaunit.assertEquals(string_count(netjson, '"tx_errors":0'), 3)
end

function TestNetJSON.test_wifi_interfaces_when_iwinfo_channel_empty()
  local netjson_file = assert(loadfile('../files/sbin/netjson-monitoring.lua'))
  local netjson = cjson.decode(netjson_file('wlan0 wlan1 wlan2 mesh1'))
  luaunit.assertEquals(netjson["interfaces"][1]["name"], "wlan2")
  -- the `wireless` key should be missing when "iwinfo.channel" is `nil`
  luaunit.assertNil(netjson["interfaces"][1]["wireless"])
  luaunit.assertEquals(netjson["interfaces"][2]["name"], "mesh1")
  luaunit.assertIsTable(netjson["interfaces"][2]["wireless"])
  luaunit.assertEquals(netjson["interfaces"][3]["name"], "wan")
  luaunit.assertEquals(netjson["interfaces"][4]["name"], "wlan1")
  luaunit.assertIsTable(netjson["interfaces"][4]["wireless"])
  luaunit.assertEquals(netjson["interfaces"][5]["name"], "mesh0")
  luaunit.assertIsTable(netjson["interfaces"][5]["wireless"])
  luaunit.assertEquals(netjson["interfaces"][6]["name"], "wlan0")
  luaunit.assertIsTable(netjson["interfaces"][6]["wireless"])
end

os.exit(luaunit.LuaUnit.run())
