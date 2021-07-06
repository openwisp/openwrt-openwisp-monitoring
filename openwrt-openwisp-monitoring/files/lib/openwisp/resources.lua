-- retrieve resources usage
local resources = {}

function resources.parse_disk_usage()
    local file = io.popen('df')
    local disk_usage_info = {}
    for line in file:lines() do
        if line:sub(1, 10) ~= 'Filesystem' then
            local filesystem, size, used, available, percent, location =
                line:match('(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
            if filesystem ~= 'tmpfs' and not string.match(filesystem, 'overlayfs') then
                percent = percent:gsub('%W', '')
                -- available, size and used are in KiB
                table.insert(disk_usage_info, {
                    filesystem = filesystem,
                    available_bytes = tonumber(available) * 1024,
                    size_bytes = tonumber(size) * 1024,
                    used_bytes = tonumber(used) * 1024,
                    used_percent = tonumber(percent),
                    mount_point = location
                })
            end
        end
    end
    file:close()
    return disk_usage_info
end

function resources.get_cpus()
    local processors = io.popen('cat /proc/cpuinfo | grep -c processor')
    local cpus = tonumber(processors:read('*a'))
    processors:close()
    return cpus
end

return resources
