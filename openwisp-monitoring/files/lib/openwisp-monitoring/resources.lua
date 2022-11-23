-- retrieve resources usage
local io = require('io')
local utils = require('openwisp-monitoring.utils')

local resources = {}

function resources.parse_disk_usage()
  local disk_usage_info = {}
  local disk_usage_file = io.popen('df')
  local disk_usage = disk_usage_file:read("*a")
  disk_usage_file:close()
  for _, line in ipairs(utils.split(disk_usage, "\n")) do
    if line:sub(1, 10) ~= 'Filesystem' then
      local filesystem, size, used, available, percent, location = line:match(
        '(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)')
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
  return disk_usage_info
end

function resources.get_cpus()
  local processors_file = io.popen('cat /proc/cpuinfo | grep -c processor')
  local processors = processors_file:read('*a')
  processors_file:close()
  local cpus = tonumber(processors)
  -- assume the hardware has at least 1 proc
  if cpus == 0 then return 1 end
  return cpus
end

return resources
