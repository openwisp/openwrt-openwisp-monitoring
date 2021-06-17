package.path = package.path .. ";../files/lib/?.lua"

local env = {}
local dhcp_data = require('test_files/dhcp_data')
local test_file_dir = './test_files/'

env.uci = {
    cursor = function()
        return {
            get_all = function(...)
                local arg = {...}
                if arg[2]=='dhcp' then
                    return dhcp_data.config
                elseif arg[2] == 'openvpn' then
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

env.io = {
    popen = function(arg)
        if arg == 'df' then
            return io.open(test_file_dir .. 'disk_usage.txt')
        elseif arg == 'cat /proc/cpuinfo | grep -c processor' then
            local f = assert(io.tmpfile())
            f:write('8')
            f:seek('set',0)
            return f
        elseif arg == 'cat /proc/net/arp 2> /dev/null' then
            return io.open(test_file_dir .. 'parse_app.txt')
        elseif arg == 'ip -json neigh 2> /dev/null' then
            return io.open(test_file_dir .. 'ip_json_neigh.txt')
        elseif arg == 'ip neigh 2> /dev/null' then
            return io.open(test_file_dir .. 'ip_neigh.txt')
        end
    end,
    open = function(arg)
        if arg == '/tmp/dhcp.leases' then
            return io.open('./test_files/dhcp_leases.txt')
        else
            return io.open(arg)
        end
    end
}

env.ubus = {
    connect = function()
        return {
            call = function(...)
                local arg = {...}
                if arg[2]=='network.interface' and arg[3]=='dump' then
                    local f = require('test_files/interface_data')
                    return f.interface_data
                end
            end
        }
    end
}

return env
