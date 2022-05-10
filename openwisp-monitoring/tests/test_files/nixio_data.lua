local nixio_data = {
  {
    addr = "00:00:00:00:00:00",
    broadaddr = "00:00:00:00:00:00",
    data = {
      collisions = 0,
      multicast = 0,
      rx_bytes = 19931,
      rx_dropped = 0,
      rx_errors = 0,
      rx_packets = 196,
      tx_bytes = 19931,
      tx_dropped = 0,
      tx_errors = 0,
      tx_packets = 196
    },
    dstaddr = "00:00:00:00:00:00",
    family = "packet",
    flags = {
      broadcast = false,
      loopback = true,
      multicast = false,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    hatype = 772,
    ifindex = 1,
    name = "lo"
  }, {
    addr = "08:00:27:d1:90:b0",
    broadaddr = "ff:ff:ff:ff:ff:ff",
    data = {
      collisions = 0,
      multicast = 105,
      rx_bytes = 524164,
      rx_dropped = 0,
      rx_errors = 0,
      rx_packets = 5397,
      tx_bytes = 808210,
      tx_dropped = 0,
      tx_errors = 0,
      tx_packets = 5520
    },
    dstaddr = "ff:ff:ff:ff:ff:ff",
    family = "packet",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    hatype = 1,
    ifindex = 2,
    name = "eth0"
  }, {
    addr = "08:00:27:71:22:91",
    broadaddr = "ff:ff:ff:ff:ff:ff",
    data = {
      collisions = 0,
      multicast = 0,
      rx_bytes = 6120,
      rx_dropped = 0,
      rx_errors = 0,
      rx_packets = 50,
      tx_bytes = 6906,
      tx_dropped = 0,
      tx_errors = 0,
      tx_packets = 68
    },
    dstaddr = "ff:ff:ff:ff:ff:ff",
    family = "packet",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    hatype = 1,
    ifindex = 3,
    name = "eth1"
  }, {
    addr = "08:00:27:48:be:0a",
    broadaddr = "ff:ff:ff:ff:ff:ff",
    data = {
      collisions = 0,
      multicast = 103,
      rx_bytes = 4560379,
      rx_dropped = 0,
      rx_errors = 0,
      rx_packets = 3825,
      tx_bytes = 142661,
      tx_dropped = 0,
      tx_errors = 0,
      tx_packets = 1749
    },
    dstaddr = "ff:ff:ff:ff:ff:ff",
    family = "packet",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    hatype = 1,
    ifindex = 4,
    name = "eth2"
  }, {
    addr = "08:00:27:d1:90:b0",
    broadaddr = "ff:ff:ff:ff:ff:ff",
    data = {
      collisions = 0,
      multicast = 0,
      rx_bytes = 448294,
      rx_dropped = 0,
      rx_errors = 0,
      rx_packets = 5391,
      tx_bytes = 806630,
      tx_dropped = 0,
      tx_errors = 0,
      tx_packets = 5519
    },
    dstaddr = "ff:ff:ff:ff:ff:ff",
    family = "packet",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    hatype = 1,
    ifindex = 5,
    name = "br-mng"
  }, {
    addr = "127.0.0.1",
    broadaddr = "127.0.0.1",
    data = {},
    dstaddr = "127.0.0.1",
    family = "inet",
    flags = {
      broadcast = false,
      loopback = true,
      multicast = false,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "lo",
    netmask = "255.0.0.0",
    prefix = 8
  }, {
    addr = "10.0.3.15",
    broadaddr = "10.0.3.255",
    data = {},
    dstaddr = "10.0.3.255",
    family = "inet",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "eth1",
    netmask = "255.255.255.0",
    prefix = 24
  }, {
    addr = "192.168.0.146",
    broadaddr = "192.168.0.255",
    data = {},
    dstaddr = "192.168.0.255",
    family = "inet",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "eth2",
    netmask = "255.255.255.0",
    prefix = 24
  }, {
    addr = "192.168.56.2",
    broadaddr = "192.168.56.255",
    data = {},
    dstaddr = "192.168.56.255",
    family = "inet",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "br-mng",
    netmask = "255.255.255.0",
    prefix = 24
  }, {
    addr = "::1",
    data = {},
    family = "inet6",
    flags = {
      broadcast = false,
      loopback = true,
      multicast = false,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "lo",
    netmask = "ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff",
    prefix = 128
  }, {
    addr = "fe80::a00:27ff:fe71:2291",
    data = {},
    family = "inet6",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "eth1",
    netmask = "ffff:ffff:ffff:ffff::",
    prefix = 64
  }, {
    addr = "fdf7:0c44:27ae:fe48:be0a",
    data = {},
    family = "inet6",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "eth2",
    netmask = "ffff:ffff:ffff:ffff::",
    prefix = 64
  }, {
    addr = "fe81::a00:27ff:fed1:90b0",
    data = {},
    family = "inet6",
    flags = {
      broadcast = true,
      loopback = false,
      multicast = true,
      noarp = false,
      pointtopoint = false,
      promisc = false,
      up = true
    },
    name = "br-mng",
    netmask = "ffff:ffff:ffff:ffff::",
    prefix = 64
  }
}

return nixio_data
