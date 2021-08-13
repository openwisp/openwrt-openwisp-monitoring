package.path = package.path .. ";../files/lib/openwisp_monitoring/?.lua;../files/sbin/?.lua"

local luaunit = require('luaunit')

local neighbor_data = require('test_files/neighbors_data')

TestNeighbor = {
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

function TestNeighbor.testArpTable()
  local neighbor = require('neighbors')

  luaunit.assertEquals(neighbor.parse_arp(), neighbor_data.sample_parse_arp)

  luaunit.assertEquals(neighbor.get_ip_neigh_json(), neighbor_data.sample_ip_neigh)

  luaunit.assertEquals(neighbor.get_ip_neigh(), neighbor_data.sample_ip_neigh)

  luaunit.assertEquals(neighbor.get_neighbors(), neighbor_data.sample_ip_neigh)
end

function TestNetJSON.test_netjson_monitoring_neighbors()
  local test_file_dir = './test_files/'
  package.loaded.io = {
    popen = function(arg)
      local f = assert(io.tmpfile())
      if arg == 'cat /proc/loadavg' then
        f:write('0.37 0.95 1.23 2/873 56899\n')
      elseif arg == 'ip -json neigh 2> /dev/null' then
        f:write("Not Valid JSoN")
      elseif arg == 'ip neigh 2> /dev/null' then
        return io.open(test_file_dir .. 'ip_neigh.txt')
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
  luaunit.assertNotNil(test_file_dir .. 'ip_neigh.txt')
  luaunit.assertNotNil(string.find(netjson, '"mac":"bc:0f:9a:17:5a:5c"'))
  luaunit.assertNotNil(string.find(netjson, '"ip":"fe80::bfca:28ed:f368:6cbc"'))
  luaunit.assertNotNil(string.find(netjson, '"interface":"eth1"'))

end

os.exit(luaunit.LuaUnit.run())
