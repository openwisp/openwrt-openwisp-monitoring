local wifi = {}

-- helpers
wifi.iwinfo_modes = {
  ['Master'] = 'access_point',
  ['Client'] = 'station',
  ['Mesh Point'] = '802.11s',
  ['Ad-Hoc'] = 'adhoc'
}

function wifi.needs_inversion(interface)
  return interface.type == 'wireless' and interface.wireless.mode == 'access_point'
end

function wifi.invert_rx_tx(interface)
  for k, v in pairs(interface) do
    if string.sub(k, 0, 3) == "rx_" then
      local tx_key = "tx_" .. string.sub(k, 4)
      local tx_val = interface[tx_key]
      interface[tx_key] = v
      interface[k] = tx_val
    end
  end
  return interface
end

function wifi.parse_hostapd_clients(clients)
  local data = {}
  for mac, properties in pairs(clients) do
    properties.mac = mac
    table.insert(data, properties)
  end
  return data
end

function wifi.parse_iwinfo_clients(clients)
  local data = {}
  for _, p in pairs(clients) do
    local client = {}
    client.ht = p.rx.ht
    client.mac = p.mac
    client.authorized = p.authorized
    client.vht = p.rx.vht
    client.wmm = p.wme
    client.mfp = p.mfp
    client.auth = p.authenticated
    client.signal = p.signal
    client.noise = p.noise
    table.insert(data, client)
  end
  return data
end

-- takes ubus wireless.status clients output and converts it to NetJSON
function wifi.netjson_clients(clients, is_mesh)
  return (is_mesh and wifi.parse_iwinfo_clients(clients) or
           wifi.parse_hostapd_clients(clients))
end

return wifi
