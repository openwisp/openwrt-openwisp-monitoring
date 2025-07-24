local wifi = {}

-- helpers
wifi.iwinfo_modes = {
  ['Master'] = 'access_point',
  ['Client'] = 'station',
  ['Mesh Point'] = '802.11s',
  ['Ad-Hoc'] = 'adhoc'
}

function wifi.needs_inversion(interface)
  if interface.wireless then
    return interface.type == 'wireless' and interface.wireless.mode == 'access_point'
  end
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

function wifi.parse_hostapd_clients(clients,exclude_mac)
  local data = {}
  if not exclude_mac then
    exclude_mac = {}
  end
  for mac, properties in pairs(clients) do
    exclude_mac_b = false
    for emac in pairs(exclude_mac) do
      if string.find(mac,emac) == 1 then
        exclude_mac_b = true
      end
    end
    if not exclude_mac_b then
      properties.mac = mac
      table.insert(data, properties)
    end
  end
  if #data > 0 then return data end
end

function wifi.parse_iwinfo_clients(clients,exclude_mac)
  local data = {}
  if not exclude_mac then
    exclude_mac = {}
  end
  for _, p in pairs(clients) do
    exclude_mac_b = false
    for emac in pairs(exclude_mac) do
      if string.find(p.mac,emac) == 1 then
        exclude_mac_b = true
      end
    end
    if not exclude_mac_b then
      local client = {}
      client.mac = p.mac
      client.ht = p.rx.ht
      client.vht = p.rx.vht
      client.he = p.rx.he
      client.auth = p.authenticated
      client.authorized = p.authorized
      client.wmm = p.wme
      client.mfp = p.mfp
      client.signal = p.signal
      client.noise = p.noise
      client.signal_avg = p.signal_avg
      client.mesh_llid = p['mesh llid']
      client.mesh_plid = p['mesh plid']
      client.mesh_plink = p['mesh plink']
      client.mesh_local_ps = p['mesh local PS']
      client.mesh_peer_ps = p['mesh peer PS']
      client.mesh_non_peer_ps = p['mesh non-peer PS']
      if p.thr then
        -- collect expected throughput in bytes
        client.throughput = p.thr * 1000
      end
      table.insert(data, client)
    end
  end
  if #data > 0 then return data end
end

-- takes ubus wireless.status clients output and converts it to NetJSON
function wifi.netjson_clients(clients, is_mesh, exclude_mac)
  return (is_mesh and wifi.parse_iwinfo_clients(clients, exclude_mac) or
           wifi.parse_hostapd_clients(clients, exclude_mac))
end 

return wifi
