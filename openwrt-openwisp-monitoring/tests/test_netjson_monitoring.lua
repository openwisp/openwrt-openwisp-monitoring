local test_file_dir = './test_files/'

package.path = package.path .. ";../files/sbin/?.lua"
package.loaded.ubus = {
    connect =function()
        return {
            call = function(...)
                local arg = {...}
                if arg[2]=='system' and arg[3]=='board' then
                    return {hostname = "08-00-27-56-92-F5"}
                elseif arg[2]=='system' and arg[3]=='info' then
                    return {
                        memory=nil,
                        local_time=nil,
                        uptime=nil,
                        swap=nil
                    }
                else
                    return {}
                end
            end
        }
    end
}

package.loaded.uci = {
    cursor = function()
        return {
            get_all = function(...)
                return nil
            end,
            get = function(...)
                return nil
            end
        }
    end
}

package.loaded.io = {
    popen = function(arg)
        if arg == 'cat /proc/loadavg' then
            local f = assert(io.tmpfile())
            f:write('0.37 0.95 1.23 2/873 56899\n')
            f:seek('set',0)
            return f
        end
        local f = assert(io.tmpfile())
        f:write('')
        f:seek('set',0)
        return f
    end,
    open = function(arg)
        return nil
    end
}

local luaunit = require('luaunit')

TestNetJson = {
    setUp = function()
    end,
    tearDown = function()
    end
}

function TestNetJson.test_resources()
    package.loaded.io = {
        popen = function(arg)
            if arg == 'cat /proc/loadavg' then
                local f = assert(io.tmpfile())
                f:write('0.37 0.95 1.23 2/873 56899\n')
                f:seek('set',0)
                return f
            elseif arg == 'df' then
                return io.open(test_file_dir .. 'disk_usage.txt')
            elseif arg == 'cat /proc/cpuinfo | grep -c processor' then
                local f = assert(io.tmpfile())
                f:write('8')
                f:seek('set',0)
                return f
            end
            local f = assert(io.tmpfile())
            f:write('')
            f:seek('set',0)
            return f
        end,
        open = function(arg)
            return nil
        end
    }
    local netjson = require('netjson-monitoring')
    luaunit.assertNotNil(test_file_dir .. 'disk_usage.txt')
    luaunit.assertNotNil(string.find(netjson, '"cpus":8'))
    luaunit.assertNotNil(string.find(netjson, '"filesystem":"\\/dev\\/root"'))
    luaunit.assertNotNil(string.find(netjson, '"used_percent":25'))
end

os.exit( luaunit.LuaUnit.run() )
