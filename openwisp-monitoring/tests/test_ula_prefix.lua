package.path = package.path .. ";../files/lib/openwisp-monitoring/?.lua" ..
                 ";../files/lib/?.lua"

local luaunit = require('luaunit')

local interface_data = require('test_files/interface_data')

TestUla = {
  setUp = function()
    local env = require('main_env')
    package.loaded.ubus = env.ubus
    package.loaded.uci = {
      cursor = function()
        return {
          get = function(...) return nil end,
          foreach = function(...) return nil end
        }
      end
    }
    package.loaded.nixio = {
      getifaddrs = function() return require('test_files/nixio_data') end
    }
  end,
  tearDown = function() end
}

function TestUla.test_ula_prefix()
  local interface_functions = require('interfaces')
  luaunit.assertEquals(interface_functions.get_addresses('lo'), {
    {address = "127.0.0.1", family = "ipv4", mask = 8, proto = "static"}
  })
  luaunit.assertEquals(interface_functions.get_addresses('br-mng')[1],
    interface_data.br_mng_addresses[1])
  luaunit.assertNotEquals(interface_functions.get_addresses('br-mng')[2],
    interface_data.br_mng_addresses[2])
end

os.exit(luaunit.LuaUnit.run())
