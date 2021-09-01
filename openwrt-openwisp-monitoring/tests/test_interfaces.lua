package.path = package.path .. ";../files/lib/openwisp_monitoring/?.lua"

local luaunit = require('luaunit')

local address_data = require('test_files/address_data')
local interface_data = require('test_files/interface_data')

TestInterface = {
  setUp = function()
    local env = require('main_env')
    package.loaded.uci = env.uci
    package.loaded.ubus = env.ubus
    package.loaded.io = env.io
    package.loaded.nixio = {
      getifaddrs = function() return require('test_files/nixio_data') end
    }
  end,
  tearDown = function() end
}

TestNetJSON = {
  setUp = function()
    local test_file_dir = './test_files/'
    package.loaded.io = {
      popen = function(arg)
        if arg == 'cat /proc/loadavg' then
          local f = assert(io.tmpfile())
          f:write('0.37 0.95 1.23 2/873 56899\n')
          f:seek('set', 0)
          return f
        else
          local modem = '/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/' ..
                          'xhci-hcd.0.auto/usb2/2-1'
          if arg == 'mmcli --output-json -m ' .. modem then
            return io.open(test_file_dir .. 'modem_data.txt')
          elseif arg == 'mmcli --output-json -m ' .. modem .. ' --signal-get' then
            return io.open(test_file_dir .. 'lte_sample.txt')
          end
        end
        local f = assert(io.tmpfile())
        f:write('')
        f:seek('set', 0)
        return f
      end,
      open = function(arg) return nil end,
      write = function(...) return nil end
    }
    package.loaded.uci = {
      cursor = function()
        return {
          get_all = function(...) return nil end,
          get = function(...)
            local arg = {...}
            if arg[1] == 'network' and arg[3] == 'stp' then
              return '1'
            elseif arg[1] == 'network' and arg[3] == 'device' then
              return '/sys/devices/platform/soc/8af8800.usb3/8a00000.dwc3/' ..
                       'xhci-hcd.0.auto/usb2/2-1'
            end
            return nil
          end
        }
      end
    }

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
              return require('test_files/network_data').devices
            elseif arg[2] == 'network.interface' and arg[3] == 'dump' then
              local f = require('test_files/interface_data')
              return f.interface_data
            else
              return {}
            end
          end
        }
      end
    }
    package.loaded.nixio = {
      getifaddrs = function() return require('test_files/nixio_data') end
    }
  end,
  tearDown = function() end
}

function TestInterface.test_find_default_gateway()
  local interface_functions = require('interfaces')
  luaunit.assertEquals(interface_functions.find_default_gateway(address_data.routes),
    "192.168.0.1")
end

function TestInterface.test_new_address_array()
  local interface_functions = require('interfaces')
  luaunit.assertEquals(interface_functions.new_address_array(
    address_data.ipv4_address, address_data.eth2_interface, 'ipv4'),
    address_data.address_array)
end

function TestInterface.test_get_vpn_interfaces()
  local interface_functions = require('interfaces')
  luaunit.assertEquals(interface_functions.get_vpn_interfaces(), {tun = true})
end

function TestInterface.test_get_addresses()
  local interface_functions = require('interfaces')
  luaunit.assertEquals(interface_functions.get_addresses('random'),
    interface_data.random_interface_address)
  luaunit.assertEquals(interface_functions.get_addresses('eth1'),
    interface_data.eth1_addresses)
  luaunit.assertEquals(interface_functions.get_addresses('eth2'),
    interface_data.eth2_addresses)
  luaunit.assertEquals(interface_functions.get_addresses('br-mng'),
    interface_data.br_mng_addresses)
end

function TestInterface.test_get_interface_info()
  local interface_functions = require('interfaces')
  local interface_info = interface_functions.get_interface_info('br-lan',
    interface_data.br_lan_interface)
  luaunit.assertEquals(interface_info,
    {dns_servers = {"8.8.8.8", "8.8.4.4"}, stp = true})
end

function TestInterface.test_specialized_info()
  local interface_functions = require('interfaces')
  local interface_info = interface_functions.get_interface_info('lan2',
    interface_data.lan2_interface)
  luaunit.assertNotNil(interface_info)
  luaunit.assertNotNil(interface_info.specialized)
  local specialized_info = interface_info.specialized.mobile
  luaunit.assertEquals(specialized_info.connection_status, "connected")
  luaunit.assertEquals(specialized_info.manufacturer, "Quectel")
  luaunit.assertEquals(specialized_info.model, "EM12-G")
  luaunit.assertEquals(specialized_info.power_status, "on")
  luaunit.assertNil(specialized_info.signal["5g"])
  luaunit.assertNil(specialized_info.signal["evdo"])
  luaunit.assertNil(specialized_info.signal["gsm"])
  luaunit.assertNil(specialized_info.signal["lte"])
  luaunit.assertNotNil(specialized_info.signal["umts"])
  luaunit.assertEquals(specialized_info.signal.umts.ecio, -3.5)
  luaunit.assertEquals(specialized_info.signal.umts.rscp, -96)
  luaunit.assertEquals(specialized_info.signal.umts.rssi, nil)
end

function TestNetJSON.test_netjson_monitoring()
  local netjson_file = assert(loadfile('../files/sbin/netjson-monitoring.lua'))
  local netjson = netjson_file('*')
  luaunit.assertNil(string.find(netjson, '"umts"', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"address":"192.168.1.41"', 1, true))
  luaunit.assertNotNil(string.find(netjson, '"stp":true', 1, true))
  luaunit.assertNotNil(string.find(netjson,
    '"lte":{"snr":19.2,"rssi":-64,"rsrq":-9,"rsrp":-92}', 1, true))
  luaunit.assertNotNil(string.find(netjson, 'dns_servers":["8.8.8.8","8.8.4.4"]', 1,
    true))
end

function TestNetJSON.test_only_existing_bridge_members_add()
  local netjson_file = assert(loadfile('../files/sbin/netjson-monitoring.lua'))
  local netjson = netjson_file('*')
  luaunit.assertNotNil(string.find(netjson, '"bridge_members":["lan2"]', 1, true))
end

os.exit(luaunit.LuaUnit.run())
