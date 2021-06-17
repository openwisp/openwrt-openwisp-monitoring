package.path = package.path .. ";../files/lib/openwisp/?.lua"

local luaunit = require('luaunit')

local neighbor_data = require('test_files/neighbors_data')

TestNeighbor = {
    setUp = function()
    local env = require('env1')
    package.loaded.io = env.io
    end,
    tearDown = function()
    end
}

function TestNeighbor.testArpTable()
    local neighbor = require('neighbors')

    luaunit.assertEquals(neighbor.parse_arp(), neighbor_data.sample_parse_arp)

    luaunit.assertEquals(neighbor.get_ip_neigh_json(), neighbor_data.sample_ip_neigh)

    luaunit.assertEquals(neighbor.get_ip_neigh(), neighbor_data.sample_ip_neigh)

    luaunit.assertEquals(neighbor.get_neighbors(), neighbor_data.sample_ip_neigh)
end

os.exit( luaunit.LuaUnit.run() )
