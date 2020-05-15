-- os = require('os')
-- -- a=os.execute('cat /proc/cpuinfo | grep -c processor')
-- -- print(a)

-- io = require('io')
-- json = require('cjson')
-- a=io.popen('cat /proc/cpuinfo | grep -c processor')

-- print(tonumber(a:read("*a")))
-- a:close()

-- function parse_disk_usage()
   -- file = io.popen('df')
   -- disk_usage_info = {}
   -- for line in file:lines() do
      -- if line:sub(1, 10) ~= 'Filesystem' then
         -- filesystem, memory, used, available, percent, location = line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
         -- percent = percent:gsub('%W', '')
         -- print(tonumber(percent))
      -- end
   -- end
   -- file:close()
   -- return disk_usage_info
-- end

-- parse_disk_usage()

-- a = json.encode(parse_disk_usage()):gsub('\\', '')
-- print(a)

a = 'a'
if a~='var' and a~='b' then
   print(a)
end