package.path = package.path .. ";../files/lib/?.lua"

local luaunit = require('luaunit')

local test_file_dir = './test_files/'
local address_data = require('test_files/address_data')
local nixio_data = require('test_files/nixio_data')
local interface_data = require('test_files/interface_data')


TestInterface = {
    setUp = function()
        local env = require('env1')
        package.loaded.uci = env.uci
        package.loaded.ubus = env.ubus
        package.loaded.io = env.io
    end,
    tearDown = function()
    end
}

function TestInterface.test_find_default_gateway()
    local interface_functions = require('openwisp.interfaces')
    luaunit.assertEquals(interface_functions.find_default_gateway(address_data.routes), "192.168.0.1")
end

function TestInterface.test_new_address_array()
    local interface_functions = require('openwisp.interfaces')
    luaunit.assertEquals(interface_functions.new_address_array(
        address_data.ipv4_address,
        address_data.eth2_interface, 'ipv4'),
    address_data.address_array)
end

function TestInterface.test_get_vpn_interfaces()
    local interface_functions = require('openwisp.interfaces')
    luaunit.assertEquals(interface_functions.get_vpn_interfaces(), {tun=true})
end

function test_get_addresses()
    local interface_functions = require('openwisp.interfaces')
    luaunit.assertEquals(interface_functions.get_addresses('random'), interface_data.random_interface_address)
    luaunit.assertEquals(interface_functions.get_addresses('eth1'), interface_data.eth1_addresses)
    luaunit.assertEquals(interface_functions.get_addresses('br-mng'), interface_data.br_mng_addresses)
end
os.exit( luaunit.LuaUnit.run() )
