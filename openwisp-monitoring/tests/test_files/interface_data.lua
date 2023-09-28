local test_data = {}

test_data.interface_data = {
  interface = {
    {
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
      uptime = 132
    }, {
      autostart = true,
      available = true,
      data = {leasetime = 86400},
      delegation = true,
      device = "br-lan",
      ["dns-search"] = {},
      ["dns-server"] = {"8.8.8.8", "8.8.4.4"},
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
      ["ipv4-address"] = {{address = "192.168.1.41", mask = 24}},
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {{address = "fd78:adb4:afb2::", mask = 60}},
      l3_device = "br-lan",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "dhcp",
      route = {
        {
          target = "0.0.0.0",
          mask = 0,
          nexthop = "192.168.1.1",
          source = "192.168.1.41/32"
        }
      },
      up = true,
      updated = {"addresses"},
      uptime = 773875
    }, {
      autostart = true,
      available = true,
      data = {},
      delegation = true,
      device = "lan2",
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
      interface = "modem",
      ["ipv4-address"] = {},
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {},
      l3_device = "lan2",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "modemmanager",
      route = {},
      up = true,
      updated = {"addresses"},
      uptime = 7738
    }, {
      autostart = true,
      available = true,
      data = {leasetime = 86400},
      delegation = true,
      device = "br-lan2",
      ["dns-search"] = {},
      ["dns-server"] = {"8.8.8.8", "8.8.4.4"},
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
      interface = "lan3",
      ["ipv4-address"] = {{address = "192.168.1.42", mask = 24}},
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {{address = "fd78:adb4:afb3::", mask = 60}},
      l3_device = "br-lan2",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "dhcp",
      route = {
        {
          target = "0.0.0.0",
          mask = 0,
          nexthop = "192.168.1.1",
          source = "192.168.1.41/32"
        }
      },
      up = true,
      updated = {"addresses"},
      uptime = 773875
    }, {
      autostart = true,
      available = true,
      data = {leasetime = 86400},
      delegation = true,
      device = "br-lan3",
      ["dns-search"] = {},
      ["dns-server"] = {"8.8.8.8", "8.8.4.4"},
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
      interface = "lan3",
      ["ipv4-address"] = {{address = "192.168.1.42", mask = 24}},
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {{address = "fd78:adb4:afb3::", mask = 60}},
      l3_device = "br-lan3",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "dhcp",
      route = {
        {
          target = "0.0.0.0",
          mask = 0,
          nexthop = "192.168.1.1",
          source = "192.168.1.41/32"
        }
      },
      up = true,
      updated = {"addresses"},
      uptime = 773875
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
      ["ipv4-address"] = {{address = "127.0.0.1", mask = 8}},
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
      updated = {"addresses"},
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
      ["ipv4-address"] = {{address = "192.168.56.2", mask = 24}},
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
      updated = {"addresses"},
      uptime = 135
    }, {
      autostart = true,
      available = true,
      data = {leasetime = 600},
      delegation = true,
      device = "eth1",
      ["dns-search"] = {},
      ["dns-server"] = {"10.0.2.1"},
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
      ["ipv4-address"] = {{address = "10.0.2.4", mask = 24}},
      ["ipv6-address"] = {{address = "2001:0db8:85a3:0000:0000:8a2e:0370:7334"}},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {},
      l3_device = "eth1",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "dhcp",
      route = {
        {mask = 0, nexthop = "10.0.2.1", source = "10.0.2.4/32", target = "0.0.0.0"}
      },
      up = true,
      updated = {"addresses", "routes", "data"},
      uptime = 132
    }, {
      autostart = true,
      available = true,
      data = {},
      delegation = true,
      device = "wg0",
      ["dns-server"] = {},
      ["dns-search"] = {},
      dns_metric = 0,
      dynamic = false,
      inactive = {
        ["ipv4-address"] = {},
        ["ipv6-address"] = {},
        route = {},
        ["dns-server"] = {},
        ["dns-search"] = {},
        neighbors = {}
      },
      interface = "wg0",
      ["ipv4-address"] = {{address = "172.16.0.9", mask = 32}},
      ["ipv6-address"] = {},
      ["ipv6-prefix"] = {},
      ["ipv6-prefix-assignment"] = {},
      l3_device = "wg0",
      metric = 0,
      neighbors = {},
      pending = false,
      proto = "wireguard",
      route = {
        {target = "172.16.0.1", mask = 32, nexthop = "0.0.0.0", source = "0.0.0.0/0"}
      },
      up = true,
      updated = {"addresses", "routes"},
      uptime = 81437
    }
  }
}

test_data.random_interface_address = {}

test_data.eth1_addresses = {
  {
    address = "10.0.2.4",
    family = "ipv4",
    gateway = "10.0.2.1",
    mask = 24,
    proto = "dhcp"
  }, {
    address = "2001:0db8:85a3:0000:0000:8a2e:0370:7334",
    family = "ipv6",
    gateway = "10.0.2.1",
    proto = "dhcp"
  }, {address = "10.0.3.15", family = "ipv4", mask = 24, proto = "dhcp"},
  {address = "fe80::a00:27ff:fe71:2291", family = "ipv6", mask = 64, proto = "static"}
}

test_data.eth2_addresses = {
  {
    address = "192.168.0.144",
    family = "ipv4",
    gateway = "192.168.0.1",
    mask = 24,
    proto = "dhcp"
  }, {address = "192.168.0.146", family = "ipv4", mask = 24, proto = "dhcp"},
  {address = "fdf7:0c44:27ae:fe48:be0a", family = "ipv6", mask = 64, proto = "static"}
}

test_data.br_mng_addresses = {
  {address = "192.168.56.2", family = "ipv4", mask = 24, proto = "static"},
  {address = "fe81::a00:27ff:fed1:90b0", family = "ipv6", mask = 64, proto = "dhcp"}
}

test_data.br_lan_interface = {
  addresses = {
    {
      address = "192.168.1.41",
      family = "ipv4",
      gateway = "192.168.1.1",
      mask = 24,
      proto = "dhcp"
    }
  },
  bridge_members = {
    "lan1", "lan2", "mesh0", "mesh1", "wan", "wlan0", "wlan1", "wlan2"
  },
  mac = "00:00:00:00:00:00",
  mtu = 1500,
  multicast = true,
  name = "br-lan",
  txqueuelen = 1000,
  type = "bridge",
  up = true
}

test_data.br_lan2_interface = {
  bridge_members = {
    "lan1", "lan2", "mesh0", "mesh1", "wan", "wlan0", "wlan1", "wlan2"
  },
  mac = "00:00:00:00:00:00",
  mtu = 1500,
  multicast = true,
  name = "br-lan2",
  txqueuelen = 1000,
  type = "bridge",
  up = true
}

test_data.br_lan3_interface = {
  bridge_members = {"lan1", "lan2"},
  mac = "00:00:00:00:00:00",
  mtu = 1500,
  multicast = true,
  name = "br-lan3",
  txqueuelen = 1000,
  type = "bridge",
  up = true
}

test_data.lan2_interface = {
  link_supported = {
    "10baseT-H", "10baseT-F", "100baseT-H", "100baseT-F", "1000baseT-F"
  },
  mac = "00:00:00:00:00:00",
  mtu = 1500,
  multicast = true,
  name = "lan2",
  speed = "-1F",
  txqueuelen = 1000,
  type = "ethernet",
  up = true
}

return test_data
