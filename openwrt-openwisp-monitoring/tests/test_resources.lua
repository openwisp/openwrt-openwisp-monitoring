package.path = package.path .. ";../files/lib/openwisp/?.lua;../files/sbin/?.lua"

local luaunit = require('luaunit')

local resources_data = require('test_files/resources_data')

TestResources = {
  setUp = function()
    local env = require('main_env')
    package.loaded.io = env.io
  end,
  tearDown = function() end
}

TestNetJSON = {
  setUp = function()
    local env = require('basic_env')
    package.loaded.uci = env.uci
    package.loaded.ubus = env.ubus
  end,
  tearDown = function() end
}

function TestResources.test_disk_usage()
  local resources = require('resources')

  luaunit.assertEquals(resources.parse_disk_usage(), resources_data.disk_usage)
end

function TestResources.test_get_cpus()
  local resources = require('resources')

  luaunit.assertEquals(resources.get_cpus(), 8)
end

function TestNetJSON.test_resources()
  local test_file_dir = './test_files/'
  package.loaded.io = {
    popen = function(arg)
      local f = assert(io.tmpfile())
      if arg == 'cat /proc/loadavg' then
        f:write('0.37 0.95 1.23 2/873 56899\n')
        f:seek('set', 0)
        return f
      elseif arg == 'df' then
        return io.open(test_file_dir .. 'disk_usage.txt')
      elseif arg == 'cat /proc/cpuinfo | grep -c processor' then
        f:write('8')
        f:seek('set', 0)
        return f
      else
        f:write('')
      end
      f:seek('set', 0)
      return f
    end,
    open = function(arg) return nil end,
    write = function(...) return nil end
  }
  local netjson = require('netjson-monitoring')
  luaunit.assertNotNil(test_file_dir .. 'disk_usage.txt')
  luaunit.assertNotNil(string.find(netjson, '"cpus":8'))
  luaunit.assertNotNil(string.find(netjson, '"filesystem":"\\/dev\\/root"'))
  luaunit.assertNotNil(string.find(netjson, '"used_percent":25'))
end

os.exit(luaunit.LuaUnit.run())
