-- retrieve neighbors information
local cjson=require('cjson')
local io=require('io')

local neighbors={}

-- defined popen function here to avoid
-- interrupted system calls in for loop
function neighbors.popen(command)
  local command_file=io.popen(command)
  local output_file=assert(io.tmpfile())
  output_file:write(command_file:read("*a"))
  command_file:close()
  output_file:seek('set',0)
  return output_file
end

-- parse /proc/net/arp
function neighbors.parse_arp()
  local arp_info={}
  for line in neighbors.popen('cat /proc/net/arp 2> /dev/null'):lines() do
    if line:sub(1, 10) ~='IP address' then
      local ip, _, _, mac, _, dev=line:match("(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
      table.insert(arp_info, {
        ip=ip,
        mac=mac,
        interface=dev,
        state=''
      })
    end
  end
  return arp_info
end

function neighbors.get_ip_neigh_json()
  local arp_info={}
  local output=neighbors.popen('ip -json neigh 2> /dev/null'):read('*a')
  if output ~=nil and pcall(cjson.decode, output) then
    local json_output=cjson.decode(output)
    for _, arp_entry in pairs(json_output) do
      table.insert(arp_info, {
        ip=arp_entry["dst"],
        mac=arp_entry["lladdr"],
        interface=arp_entry["dev"],
        state=arp_entry["state"][1]
      })
    end
  end
  return arp_info
end

function neighbors.get_ip_neigh()
  local arp_info={}
  for line in neighbors.popen('ip neigh 2> /dev/null'):lines() do
    local ip, dev, mac, state=line:match("(%S+)%s+dev%s+(%S+)%s+lladdr%s+(%S+).*%s(%S+)")
    if mac ~=nil then
      table.insert(arp_info, {
        ip=ip,
        mac=mac,
        interface=dev,
        state=state
      })
    end
  end
  return arp_info
end

function neighbors.get_neighbors()
  local arp_table=neighbors.get_ip_neigh_json()
  if next(arp_table)==nil then
    arp_table=neighbors.get_ip_neigh()
  end
  if next(arp_table)==nil then
    arp_table=neighbors.parse_arp()
  end
  return arp_table
end

return neighbors
