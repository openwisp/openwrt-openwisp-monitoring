package.path = package.path ..
                 ";../files/lib/openwisp-monitoring/?.lua;../files/sbin/?.lua"

local cjson = require('cjson')
local luaunit = require('luaunit')
local dhcp_data = require('test_files/dhcp_data')

TestDhcp = {
  setUp = function()
    local env = require('main_env')
    package.loaded.uci = env.uci
    package.loaded.io = env.io
  end,
  tearDown = function() end
}

TestNetJSON = {
  setUp = function()
    local env = require('basic_env')
    local test_file_dir = './test_files/'
    package.loaded.ubus = env.ubus
    package.loaded.io = {
      popen = function(arg)
        local f = assert(io.tmpfile())
        if arg == 'cat /proc/loadavg' then
          f:write('0.37 0.95 1.23 2/873 56899\n')
        else
          f:write('')
        end
        f:seek('set', 0)
        return f
      end,
      open = function(arg)
        if arg == '/tmp/dhcp.leases' then
          return io.open(test_file_dir .. 'dhcp_leases.txt')
        else
          return nil
        end
      end,
      write = function(...) return nil end
    }
    package.loaded.uci = {
      cursor = function()
        return {
          get_all = function(...)
            local arg = {...}
            if arg[2] == 'dhcp' then
              return dhcp_data.config
            else
              return nil
            end
          end,
          get = function(...) return nil end
        }
      end
    }
  end,
  tearDown = function() end
}

function TestDhcp.test_dhcp_leases()
  local dhcp_functions = require('dhcp')

  luaunit.assertEquals(dhcp_functions.get_dhcp_leases(), dhcp_data.leases)
  luaunit.assertEquals(dhcp_functions.parse_dhcp_lease_file('/tmp/dhcp.leases', {}),
    dhcp_data.leases)
  luaunit.assertEquals(
    dhcp_functions.parse_dhcp_lease_file('/tmp/no_dhcp.leases', {}), {})
end

function TestNetJSON.test_dhcp()
  local netjson_string = require('netjson-monitoring')
  local netjson = cjson.decode(netjson_string)
  luaunit.assertEquals(netjson["dhcp_leases"][1]["mac"], "e8:6a:64:3e:4a:3c")
  luaunit.assertEquals(netjson["dhcp_leases"][1]["client_id"], "01:e8:6a:64:3e:4a:3c")
  luaunit.assertEquals(netjson["dhcp_leases"][1]["ip"], "192.168.1.136")
  luaunit.assertEquals(netjson["dhcp_leases"][1]["expiry"], 1620788343)
end

os.exit(luaunit.LuaUnit.run())
