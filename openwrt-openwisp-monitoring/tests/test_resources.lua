package.path = package.path .. ";../files/lib/openwisp/?.lua"

local luaunit = require('luaunit')

local resources_data = require('test_files/resources_data')

TestResources = {
    setUp = function()
    local env = require('env1')
    package.loaded.io = env.io
    end,
    tearDown = function()
    end
}

function TestResources.test_disk_usage()
    local resources = require('resources')

    luaunit.assertEquals(resources.parse_disk_usage(), resources_data.disk_usage)
end

function TestResources.test_get_cpus()
    local resources = require('resources')

    luaunit.assertEquals(resources.get_cpus(), 8)
end

os.exit( luaunit.LuaUnit.run() )
