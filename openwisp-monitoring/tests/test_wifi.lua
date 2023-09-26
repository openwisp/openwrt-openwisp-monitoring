package.path = package.path ..
                 ";../files/lib/openwisp-monitoring/?.lua;../files/sbin/?.lua"

local cjson = require("cjson")
local luaunit = require('luaunit')
local wifi_functions = require('wifi')
local wifi_data = require('test_files/wireless_data')

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
              if arg[4].device == "wlan0" then
                return wifi_data.wlan0_clients
              elseif arg[4].device == "mesh0" then
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
  luaunit.assertEquals(wifi_functions.parse_hostapd_clients(wifi_data.wlan2_clients),
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
  luaunit.assertEquals(wifi_functions.netjson_clients(wifi_data.wlan2_clients, false),
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
  local netjson_string = require('netjson-monitoring')
  local netjson = cjson.decode(netjson_string)
  luaunit.assertEquals(netjson["interfaces"][5]["wireless"]["signal"], -67)
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["signal"], -76)
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["ssid"], "meshID")
  luaunit.assertEquals(netjson["interfaces"][5]["wireless"]["ssid"], "meshID")
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["tx_power"], 20)
  luaunit.assertEquals(netjson["interfaces"][4]["wireless"]["tx_power"], 20)
  luaunit.assertEquals(netjson["interfaces"][5]["wireless"]["tx_power"], 20)
  luaunit.assertEquals(netjson["interfaces"][6]["wireless"]["tx_power"], 20)
  luaunit.assertEquals(netjson["interfaces"][5]["wireless"]["clients"][1]["vht"], true)
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["clients"][1]["vht"],
    false)
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["frequency"], 5200)
  luaunit.assertEquals(netjson["interfaces"][4]["wireless"]["mode"], "access_point")
  luaunit.assertEquals(netjson["interfaces"][6]["wireless"]["mode"], "station")
  luaunit.assertEquals(netjson["interfaces"][6]["wireless"]["clients"][1]["mac"],
    "22:33:2F:9A:14:9D")
end

function TestNetJSON.test_wifi_interfaces_stats_include()
  local netjson_file = assert(loadfile('../files/sbin/netjson-monitoring.lua'))
  local netjson = cjson.decode(netjson_file('wlan0 wlan1 mesh1'))
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["channel"], 40)
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["mode"], "802.11s")
  luaunit.assertEquals(netjson["interfaces"][6]["statistics"]["rx_packets"], 198)
  luaunit.assertEquals(netjson["interfaces"][4]["statistics"]["rx_packets"], 2367515)
  luaunit.assertEquals(netjson["interfaces"][6]["statistics"]["rx_bytes"], 25967)
  luaunit.assertEquals(netjson["interfaces"][6]["statistics"]["tx_bytes"], 531641723)
  luaunit.assertEquals(netjson["interfaces"][2]["statistics"]["tx_bytes"],
  151599685066)
  luaunit.assertEquals(netjson["interfaces"][6]["statistics"]["tx_packets"], 2367747)
  luaunit.assertEquals(netjson["interfaces"][2]["statistics"]["tx_errors"], 0)
  luaunit.assertEquals(netjson["interfaces"][4]["statistics"]["tx_errors"], 0)
  luaunit.assertEquals(netjson["interfaces"][6]["statistics"]["tx_errors"], 0)
end

function TestNetJSON.test_wifi_interfaces_stats_include_htmode()
  local netjson_file = assert(loadfile('../files/sbin/netjson-monitoring.lua'))
  local netjson = cjson.decode(netjson_file('wlan0 wlan1 mesh1'))
  luaunit.assertEquals(netjson["interfaces"][1]["name"], "wlan2")
  luaunit.assertEquals(netjson["interfaces"][2]["name"], "mesh1")
  luaunit.assertEquals(netjson["interfaces"][2]["wireless"]["htmode"], "VHT80")
  luaunit.assertEquals(netjson["interfaces"][4]["name"], "wlan1")
  luaunit.assertEquals(netjson["interfaces"][4]["wireless"]["htmode"], "VHT80")
  luaunit.assertEquals(netjson["interfaces"][5]["name"], "mesh0")
  luaunit.assertEquals(netjson["interfaces"][5]["wireless"]["htmode"], "HT20")
  luaunit.assertEquals(netjson["interfaces"][6]["name"], "wlan0")
  luaunit.assertEquals(netjson["interfaces"][6]["wireless"]["htmode"], "HT20")
end

function TestNetJSON.test_wifi_interfaces_when_iwinfo_channel_empty()
  local netjson_file = assert(loadfile('../files/sbin/netjson-monitoring.lua'))
  local netjson = cjson.decode(netjson_file('wlan0 wlan1 wlan2 mesh1'))
  -- make sure the correct `name` and `type` are present in the netjson
  luaunit.assertEquals(netjson["interfaces"][1]["name"], "wlan2")
  luaunit.assertEquals(netjson["interfaces"][1]["type"], "wireless")
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
