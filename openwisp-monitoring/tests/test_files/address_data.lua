local test_data = {}

test_data.eth2_interface = {
  autostart = true,
  available = true,
  data = {hostname = "08-00-27-4F-CB-2E", leasetime = 86400},
  delegation = true,
  device = "eth2",
  ["dns-search"] = {},
  ["dns-server"] = {"192.168.0.1"},
  dns_metric = 0,
  dynamic = false,
  inactive = {
    ["dns-search"] = {},
    ["dns-server"] = {},
    ["ipv4-address"] = {},
    ["ipv6-address"] = {},
    neighbors = {},
    route = {}
  },
  interface = "lan",
  ["ipv4-address"] = {{address = "192.168.0.144", mask = 24}},
  ["ipv6-address"] = {},
  ["ipv6-prefix"] = {},
  ["ipv6-prefix-assignment"] = {},
  l3_device = "eth2",
  metric = 0,
  neighbors = {},
  pending = false,
  proto = "dhcp",
  route = {
    {
      mask = 0,
      nexthop = "192.168.0.1",
      source = "192.168.0.144/32",
      target = "0.0.0.0"
    }
  },
  up = true,
  updated = {"addresses", "routes", "data"},
  uptime = 1973
}

test_data.routes = test_data.eth2_interface.route

test_data.ipv4_address = test_data.eth2_interface['ipv4-address'][1]

test_data.address_array = {
  address = "192.168.0.144",
  family = "ipv4",
  gateway = "192.168.0.1",
  mask = 24,
  proto = "dhcp"
}

return test_data
