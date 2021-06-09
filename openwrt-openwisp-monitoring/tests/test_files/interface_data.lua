data = {}

data.interface_data = {
  interface = { {
      autostart = true,
      available = true,
      data = {
        hostname = "08-00-27-4F-CB-2E",
        leasetime = 86400
      },
      delegation = true,
      device = "eth2",
      ["dns-search"] = {},
      ["dns-server"] = { "192.168.0.1" },
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
      ["ipv4-address"] = { {
          address = "192.168.0.144",
          mask = 24
        } },
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {},
      l3_device = "eth2",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "dhcp",
      route = { {
          mask = 0,
          nexthop = "192.168.0.1",
          source = "192.168.0.144/32",
          target = "0.0.0.0"
        } },
      up = true,
      updated = { "addresses", "routes", "data" },
      uptime = 132
    }, {
      autostart = true,
      available = true,
      data = {},
      delegation = true,
      device = "lo",
      ["dns-search"] = {},
      ["dns-server"] = {},
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
      interface = "loopback",
      ["ipv4-address"] = { {
          address = "127.0.0.1",
          mask = 8
        } },
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {},
      l3_device = "lo",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "static",
      route = {},
      up = true,
      updated = { "addresses" },
      uptime = 135
    }, {
      autostart = true,
      available = true,
      data = {},
      delegation = true,
      device = "br-mng",
      ["dns-search"] = {},
      ["dns-server"] = {},
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
      interface = "mng",
      ["ipv4-address"] = { {
          address = "192.168.56.2",
          mask = 24
        } },
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {},
      l3_device = "br-mng",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "static",
      route = {},
      up = true,
      updated = { "addresses" },
      uptime = 135
    }, {
      autostart = true,
      available = true,
      data = {
        leasetime = 600
      },
      delegation = true,
      device = "eth1",
      ["dns-search"] = {},
      ["dns-server"] = { "10.0.2.1" },
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
      interface = "wan",
      ["ipv4-address"] = { {
          address = "10.0.2.4",
          mask = 24
        } },
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {},
      l3_device = "eth1",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "dhcp",
      route = { {
          mask = 0,
          nexthop = "10.0.2.1",
          source = "10.0.2.4/32",
          target = "0.0.0.0"
        } },
      up = true,
      updated = { "addresses", "routes", "data" },
      uptime = 132
    } }
}

data.random_interface_address = {}

data.eth1_addresses = {
    {address="10.0.2.4", family="ipv4", gateway="10.0.2.1", mask=24, proto="dhcp"},
    {address="10.0.3.15", family="ipv4", mask=24, proto="dhcp"},
    {address="fe80::a00:27ff:fe71:2291", family="ipv6", mask=64, proto="static"}
}

data.br_mng_addresses = {
    {address="192.168.56.2", family="ipv4", mask=24, proto="static"},
    {address="fe80::a00:27ff:fed1:90b0", family="ipv6", mask=64, proto="static"}
}

return data
