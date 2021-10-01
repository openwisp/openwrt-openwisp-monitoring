-- retrieve neighbors information
local cjson = require('cjson')
local io = require('io')
local utils = require('openwisp-monitoring.utils')

local neighbors = {}

-- parse /proc/net/arp
function neighbors.parse_arp()
  local arp_info = {}
  local arp_data_file = io.popen('cat /proc/net/arp 2> /dev/null')
  local arp_data = arp_data_file:read("*a")
  arp_data_file:close()
  for _, line in ipairs(utils.split(arp_data, "\n")) do
    if line:sub(1, 10) ~= 'IP address' then
      local ip, _, _, mac, _, dev = line:match(
        "(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)%s+(%S+)")
      table.insert(arp_info, {ip = ip, mac = mac, interface = dev, state = ''})
    end
  end
  return arp_info
end

function neighbors.get_ip_neigh_json()
  local arp_info = {}
  local output_file = io.popen('ip -json neigh 2> /dev/null')
  local output = output_file:read('*a')
  output_file:close()
  if output ~= nil and pcall(cjson.decode, output) then
    local json_output = cjson.decode(output)
    for _, arp_entry in pairs(json_output) do
      table.insert(arp_info, {
        ip = arp_entry["dst"],
        mac = arp_entry["lladdr"],
        interface = arp_entry["dev"],
        state = arp_entry["state"][1]
      })
    end
  end
  return arp_info
end

function neighbors.get_ip_neigh()
  local arp_info = {}
  local neigh_data_file = io.popen('ip neigh 2> /dev/null')
  local neigh_data = neigh_data_file:read("*a")
  neigh_data_file:close()
  for _, line in ipairs(utils.split(neigh_data, "\n")) do
    local ip, dev, mac, state = line:match(
      "(%S+)%s+dev%s+(%S+)%s+lladdr%s+(%S+).*%s(%S+)")
    if mac ~= nil then
      table.insert(arp_info, {ip = ip, mac = mac, interface = dev, state = state})
    end
  end
  return arp_info
end

function neighbors.get_neighbors()
  local arp_table = neighbors.get_ip_neigh_json()
  if next(arp_table) == nil then arp_table = neighbors.get_ip_neigh() end
  if next(arp_table) == nil then arp_table = neighbors.parse_arp() end
  return arp_table
end

return neighbors
