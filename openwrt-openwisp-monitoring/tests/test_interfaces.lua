package.path = package.path .. ";../files/lib/?.lua"

local luaunit = require('luaunit')

local address_data = require('test_files/address_data')
local interface_data = require('test_files/interface_data')

TestInterface = {
    setUp = function()
        local env = require('main_env')
        package.loaded.uci = env.uci
        package.loaded.ubus = env.ubus
        package.loaded.io = env.io
        package.loaded.nixio = {
            getifaddrs = function()
                return require('test_files/nixio_data')
            end
        }
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

function TestInterface.test_get_addresses()
    local interface_functions = require('openwisp.interfaces')
    luaunit.assertEquals(interface_functions.get_addresses('random'), interface_data.random_interface_address)
    luaunit.assertEquals(interface_functions.get_addresses('eth1'), interface_data.eth1_addresses)
    luaunit.assertEquals(interface_functions.get_addresses('eth2'), interface_data.eth2_addresses)
    luaunit.assertEquals(interface_functions.get_addresses('br-mng'), interface_data.br_mng_addresses)
end

function TestInterface.test_get_interface_info()
    local interface_functions = require('openwisp.interfaces')
    local interface_info = interface_functions.get_interface_info('br-lan', interface_data.br_lan_interface)
    luaunit.assertEquals(
        interface_info, {dns_servers={"8.8.8.8", "8.8.4.4"}, stp=true}
        )
end

function TestInterface.test_specialized_info()
    local interface_functions = require('openwisp.interfaces')
    local interface_info = interface_functions.get_interface_info('lan2', interface_data.lan2_interface)
    luaunit.assertNotNil(interface_info)
    luaunit.assertNotNil(interface_info.specialized)
    local specialized_info = interface_info.specialized.mobile
    luaunit.assertEquals(specialized_info.connection_status, "connected")
    luaunit.assertEquals(specialized_info.manufacturer, "Quectel")
    luaunit.assertEquals(specialized_info.model, "EM12-G")
    luaunit.assertEquals(specialized_info.power_status, "on")
    luaunit.assertNil(specialized_info.signal["5g"])
    luaunit.assertNil(specialized_info.signal["evdo"])
    luaunit.assertNil(specialized_info.signal["gsm"])
    luaunit.assertNil(specialized_info.signal["lte"])
    luaunit.assertNotNil(specialized_info.signal["umts"])
    luaunit.assertEquals(specialized_info.signal.umts.ecio, -3.5)
    luaunit.assertEquals(specialized_info.signal.umts.rscp, -96)
    luaunit.assertEquals(specialized_info.signal.umts.rssi, nil)
end

os.exit( luaunit.LuaUnit.run() )
