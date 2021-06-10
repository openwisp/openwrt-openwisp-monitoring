package.path = package.path .. ";../files/lib/?.lua"

local resources = require('resources')

local io = require('io')

local luaunit = require('luaunit')

local test_file_dir = './test_files/'

local resources_data = require('test_files/resources_data')

io.popen = function(arg)
	if arg == 'df' then
		return io.open(test_file_dir .. 'disk_usage.txt')
	elseif arg == 'cat /proc/cpuinfo | grep -c processor' then
		local f = assert(io.tmpfile())
		f:write('8')
		f:seek('set',0)
		return f
	end
end

function test_disk_usage()
	luaunit.assertEquals(resources.parse_disk_usage(), resources_data.disk_usage)
end

function test_get_cpus()
	luaunit.assertEquals(resources.get_cpus(), 8)
end

os.exit( luaunit.LuaUnit.run() )
