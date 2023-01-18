local utils = {}
-- split function
function utils.split(str, pat)
  local t = {}
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then table.insert(t, cap) end
    last_end = e + 1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

function utils.has_value(tab, val)
  for _, value in ipairs(tab) do if value == val then return true end end
  return false
end

function utils.starts_with(str, start) return str:sub(1, #start) == start end

function utils.is_table_empty(table_) return not table_ or not next(table_) end

function utils.array_concat(source, destination)
  table.foreach(source, function(_, value) table.insert(destination, value) end)
  return destination
end

function utils.dict_merge(source, destination)
  table.foreach(source, function(key, value) destination[key] = value end)
  return destination
end

function utils.is_excluded(name) return name == 'lo' end

function utils.is_empty(data) return data == nil or data == false or data == '' end

return utils
