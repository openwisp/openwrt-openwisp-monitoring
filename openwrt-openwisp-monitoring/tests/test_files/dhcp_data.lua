local dhcp = {}

dhcp.config = {
  dnsmasq1 = {
    [".anonymous"] = false,
    [".index"] = 0,
    [".name"] = "dnsmasq1",
    [".type"] = "dnsmasq",
    authoritative = "1",
    boguspriv = "1",
    domain = "lan",
    domainneeded = "1",
    expandhosts = "1",
    filterwin2k = "0",
    leasefile = "/tmp/dhcp.leases",
    localise_queries = "1",
    localservice = "1",
    nonegcache = "0",
    nonwildcard = "1",
    readethers = "1",
    rebind_localhost = "1",
    rebind_protection = "1",
    resolvfile = "/tmp/resolv.conf.auto"
  },
  lan = {
    [".anonymous"] = false,
    [".index"] = 1,
    [".name"] = "lan",
    [".type"] = "dhcp",
    dhcpv6 = "server",
    interface = "lan",
    leasetime = "12h",
    limit = "150",
    ra = "server",
    start = "100"
  },
  odhcpd = {
    [".anonymous"] = false,
    [".index"] = 3,
    [".name"] = "odhcpd",
    [".type"] = "odhcpd",
    leasefile = "/tmp/hosts/odhcpd",
    leasetrigger = "/usr/sbin/odhcpd-update",
    loglevel = "4",
    maindhcp = "0"
  },
  wan = {
    [".anonymous"] = false,
    [".index"] = 2,
    [".name"] = "wan",
    [".type"] = "dhcp",
    ignore = "1",
    interface = "wan"
  }
}

dhcp.leases = {
  {
    client_id = "01:e8:6a:64:3e:4a:3c",
    client_name = "FRIDAY",
    expiry = 1620788343,
    ip = "192.168.1.136",
    mac = "e8:6a:64:3e:4a:3c"
  }
}

return dhcp
