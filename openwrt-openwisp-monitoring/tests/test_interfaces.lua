package.path = package.path .. ";../?.lua"
package.loaded.ubus = {
    connect = function()
        return {
            call = function(...)
                local arg = {...}
                if arg[2]=='network.interface' and arg[3]=='dump' then
                    f = require('test_files/interface_data')
                    return f.interface_data
                end
            end
        }
    end
}

package.loaded.uci = {
    cursor = function()
        return {
            get_all = function(...)
                local arg = {...}
                if arg[2] == 'openvpn' then
                    return require('test_files/openvpn_data')
                end
            end,
            get = function(...)
                local arg = {...}
                if arg[2]=='network' and arg[4]=='ula_prefix' then
                    return "fdf7:0c44:27ae::/48"
                end
            end
        }
    end
}

local interface_functions = require('interfaces')

local luaunit = require('luaunit')

local test_file_dir = './test_files/'
local address_data = require('test_files/address_data')
local nixio_data = require('test_files/nixio_data')
local interface_data = require('test_files/interface_data')

function test_find_default_gateway()
    luaunit.assertEquals(interface_functions.find_default_gateway(address_data.routes), "192.168.0.1")
end

function test_new_address_array()
    luaunit.assertEquals(interface_functions.new_address_array(
        address_data.ipv4_address,
        address_data.eth2_interface, 'ipv4'),
    address_data.address_array)
end

function test_get_vpn_interfaces()
    luaunit.assertEquals(interface_functions.get_vpn_interfaces(), {tun=true})
end

function test_get_addresses()
    luaunit.assertEquals(interface_functions.get_addresses('random'), interface_data.random_interface_address)
    luaunit.assertEquals(interface_functions.get_addresses('eth1'), interface_data.eth1_addresses)
    luaunit.assertEquals(interface_functions.get_addresses('br-mng'), interface_data.br_mng_addresses)
    -- body
end
os.exit( luaunit.LuaUnit.run() )
