local env = {}
env.io = {
  popen = function(arg)
    if arg == 'cat /proc/loadavg' then
      local f = assert(io.tmpfile())
      f:write('0.37 0.95 1.23 2/873 56899\n')
      f:seek('set', 0)
      return f
    end
    local f = assert(io.tmpfile())
    f:write('')
    f:seek('set', 0)
    return f
  end,
  open = function(arg) return nil end,
  write = function(...) return nil end
}

env.ubus = {
  connect = function()
    return {
      call = function(...)
        local arg = {...}
        if arg[2] == 'system' and arg[3] == 'board' then
          return {hostname = "08-00-27-56-92-F5"}
        elseif arg[2] == 'system' and arg[3] == 'info' then
          return {memory = nil, local_time = nil, uptime = nil, swap = nil}
        else
          return {}
        end
      end
    }
  end
}

env.uci = {
  cursor = function()
    return {
      get_all = function(...) return nil end,
      get = function(...) return nil end,
      foreach = function(...) return nil end
    }
  end
}

return env
