local openvpn = {
  custom_config = {
    [".anonymous"] = false,
    [".index"] = 0,
    [".name"] = "custom_config",
    [".type"] = "openvpn",
    config = "/etc/openvpn/my-vpn.conf",
    enabled = "0"
  },
  sample_client = {
    [".anonymous"] = false,
    [".index"] = 2,
    [".name"] = "sample_client",
    [".type"] = "openvpn",
    ca = "/etc/openvpn/ca.crt",
    cert = "/etc/openvpn/client.crt",
    client = "1",
    compress = "lzo",
    dev = "tun",
    enabled = "0",
    key = "/etc/openvpn/client.key",
    nobind = "1",
    persist_key = "1",
    persist_tun = "1",
    proto = "udp",
    remote = {"my_server_1 1194"},
    resolv_retry = "infinite",
    user = "nobody",
    verb = "3"
  },
  sample_server = {
    [".anonymous"] = false,
    [".index"] = 1,
    [".name"] = "sample_server",
    [".type"] = "openvpn",
    ca = "/etc/openvpn/ca.crt",
    cert = "/etc/openvpn/server.crt",
    compress = "lzo",
    dev = "tun",
    dh = "/etc/openvpn/dh1024.pem",
    enabled = "0",
    ifconfig_pool_persist = "/tmp/ipp.txt",
    keepalive = "10 120",
    key = "/etc/openvpn/server.key",
    persist_key = "1",
    persist_tun = "1",
    port = "1194",
    proto = "udp",
    server = "10.8.0.0 255.255.255.0",
    status = "/tmp/openvpn-status.log",
    user = "nobody",
    verb = "3"
  }
}

return openvpn
