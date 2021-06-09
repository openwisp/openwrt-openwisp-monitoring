package.path = package.path .. ";../?.lua"
local test_file_dir = './test_files/'

local dhcp_data = require('test_files/dhcp_data')
package.loaded.uci = {
    cursor = function()
        return {
            get_all = function(...)
                local arg = {...}
                if arg[2]=='dhcp' then
                    return dhcp_data.config
                end
            end
        }
    end
}

local luaunit = require('luaunit')

local dhcp_functions = require('dhcp')

local org_io = io.open

io.open = function(arg)
	if arg == '/tmp/dhcp.leases' then
		return org_io('./test_files/dhcp_leases.txt')
	else
		return org_io(arg)
	end
end

function test_dhcp_leases()
	luaunit.assertEquals(dhcp_functions.get_dhcp_leases(), dhcp_data.leases)
    luaunit.assertEquals(dhcp_functions.parse_dhcp_lease_file('/tmp/dhcp.leases',{}), dhcp_data.leases)
end

os.exit( luaunit.LuaUnit.run() )
