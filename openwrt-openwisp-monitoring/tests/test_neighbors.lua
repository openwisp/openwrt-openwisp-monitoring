package.path = package.path .. ";../?.lua"

local luaunit = require('luaunit')

local io = require('io')

local neighbor = require('neighbors')
local neighbor_data = require('test_files/neighbors_data')

local test_file_dir = './test_files/'

io.popen = function(arg)
	if arg == 'cat /proc/net/arp 2> /dev/null' then
		return io.open(test_file_dir .. 'parse_app.txt')
	elseif arg == 'ip -json neigh 2> /dev/null' then
		return io.open(test_file_dir .. 'ip_json_neigh.txt')
	elseif arg == 'ip neigh 2> /dev/null' then
		return io.open(test_file_dir .. 'ip_neigh.txt')
	end
end

function testArpTable()

	luaunit.assertEquals(neighbor.parse_arp(), neighbor_data.sample_parse_arp)

	luaunit.assertEquals(neighbor.get_ip_neigh_json(), neighbor_data.sample_ip_neigh)

	luaunit.assertEquals(neighbor.get_ip_neigh(), neighbor_data.sample_ip_neigh)

	luaunit.assertEquals(neighbor.get_neighbors(), neighbor_data.sample_ip_neigh)
end

os.exit( luaunit.LuaUnit.run() )
