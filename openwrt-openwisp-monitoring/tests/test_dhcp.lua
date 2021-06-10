package.path = package.path .. ";../files/lib/openwisp/?.lua"

local dhcp_data = require('test_files/dhcp_data')

local luaunit = require('luaunit')

function test_dhcp_leases()
    local env = require('env1')
    package.loaded.uci = env.uci
    package.loaded.io = env.io

    local dhcp_functions = require('dhcp')
	luaunit.assertEquals(dhcp_functions.get_dhcp_leases(), dhcp_data.leases)
    luaunit.assertEquals(dhcp_functions.parse_dhcp_lease_file('/tmp/dhcp.leases',{}), dhcp_data.leases)
end

os.exit( luaunit.LuaUnit.run() )
