local test_data = {}

test_data.sample_parse_arp = {
  {interface = "eth1", ip = "10.0.2.1", mac = "52:54:00:12:35:00", state = ""},
  {interface = "br-mng", ip = "192.168.56.1", mac = "0a:00:27:00:00:00", state = ""},
  {interface = "eth2", ip = "192.168.0.1", mac = "bc:0f:9a:17:5a:5c", state = ""}
}

test_data.sample_ip_neigh = {
  {
    interface = "eth1",
    ip = "10.0.2.1",
    mac = "52:54:00:12:35:00",
    state = "REACHABLE"
  }, {
    interface = "br-mng",
    ip = "192.168.56.1",
    mac = "0a:00:27:00:00:00",
    state = "REACHABLE"
  },
  {interface = "eth2", ip = "192.168.0.1", mac = "bc:0f:9a:17:5a:5c", state = "STALE"},
  {
    interface = "br-mng",
    ip = "fe80::800:27ff:fe00:0",
    mac = "0a:00:27:00:00:00",
    state = "STALE"
  }, {
    interface = "eth2",
    ip = "fe80::22a6:cff:feb2:da10",
    mac = "20:a6:0c:b2:da:10",
    state = "STALE"
  }, {
    interface = "eth2",
    ip = "fe80::bfca:28ed:f368:6cbc",
    mac = "98:3b:8f:98:b1:fb",
    state = "STALE"
  }
}

return test_data
