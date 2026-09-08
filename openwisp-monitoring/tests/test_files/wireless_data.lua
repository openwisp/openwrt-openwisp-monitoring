local test_data = {}

test_data.wireless_status = {
  radio0 = {
    up = true,
    pending = false,
    autostart = true,
    disabled = false,
    retry_setup_failed = false,
    config = {
      channel = "11",
      hwmode = "11g",
      path = "1e140000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0",
      htmode = "HT20",
      log_level = 0,
      disabled = false
    },
    interfaces = {
      {
        section = "wifi_mesh0",
        ifname = "mesh0",
        config = {
          ifname = "mesh0",
          encryption = "psk2+ccmp",
          key = "password",
          mesh_id = "meshid",
          mode = "mesh",
          network = {"lan"}
        },
        vlans = {},
        stations = {}
      }, {
        section = "wifi_wlan0",
        ifname = "wlan0",
        config = {
          ifname = "wlan0",
          encryption = "psk2",
          key = "password",
          ssid = "OpenWRT",
          ieee80211r = true,
          ft_over_ds = true,
          ft_psk_generate_local = true,
          rsn_preauth = true,
          mode = "ap",
          network = {"lan"}
        },
        vlans = {},
        stations = {}
      }
    }
  },
  radio1 = {
    up = true,
    pending = false,
    autostart = true,
    disabled = false,
    retry_setup_failed = false,
    config = {
      hwmode = "11a",
      path = "1e140000.pcie/pci0000:00/0000:00:01.0/0000:02:00.0",
      htmode = "VHT80",
      channel = "40",
      log_level = 0,
      disabled = false
    },
    interfaces = {
      {
        section = "wifi_mesh1",
        ifname = "mesh1",
        config = {
          ifname = "mesh1",
          encryption = "psk2+ccmp",
          key = "password",
          mesh_id = "meshID",
          mode = "mesh",
          network = {"lan"}
        },
        vlans = {},
        stations = {}
      }, {
        section = "wifi_wlan1",
        ifname = "wlan1",
        config = {
          ifname = "wlan1",
          encryption = "psk2",
          key = "password",
          ssid = "ssid",
          ieee80211r = true,
          ft_over_ds = true,
          ft_psk_generate_local = true,
          rsn_preauth = true,
          mode = "ap",
          network = {"lan"}
        },
        vlans = {},
        stations = {}
      }, {
        section = "wifi_wlan2",
        ifname = "wlan2",
        config = {
          ifname = "wlan2",
          encryption = "psk2",
          key = "password",
          ssid = "ssid",
          ieee80211r = true,
          ft_over_ds = true,
          ft_psk_generate_local = true,
          rsn_preauth = true,
          mode = "ap",
          network = {"lan"}
        },
        vlans = {},
        stations = {}
      }
    }
  }
}

test_data.wlan0_clients = {
  results = {
    {
      mac = "22:33:2F:9A:14:9D",
      signal = -3,
      signal_avg = -3,
      noise = 0,
      inactive = 12100,
      connected_time = 1376,
      thr = 4500,
      authorized = true,
      authenticated = true,
      preamble = "long",
      wme = true,
      mfp = false,
      tdls = false,
      ["mesh llid"] = 0,
      ["mesh plid"] = 0,
      ["mesh plink"] = "",
      ["mesh local PS"] = "",
      ["mesh peer PS"] = "",
      ["mesh non-peer PS"] = "",
      rx = {
        drop_misc = 64,
        packets = 26932,
        bytes = 2767915,
        ht = false,
        vht = false,
        mhz = 20,
        rate = 6000
      },
      tx = {
        failed = 0,
        retries = 0,
        packets = 57,
        bytes = 2582,
        ht = false,
        vht = false,
        mhz = 20,
        rate = 6000
      }
    }
  }
}

test_data.wlan1_clients = {
  ["20:a6:0c:b2:da:10"] = {
    aid = 2,
    assoc = true,
    auth = true,
    authorized = true,
    ht = true,
    mfp = false,
    preauth = false,
    rrm = {0, 0, 0, 0, 0},
    vht = true,
    wds = false,
    wmm = true,
    wps = false
  },
  ["98:3b:8f:98:b1:fb"] = {
    aid = 1,
    assoc = true,
    auth = true,
    authorized = true,
    ht = true,
    mfp = false,
    preauth = false,
    rrm = {0, 0, 0, 0, 0},
    vht = true,
    wds = false,
    wmm = true,
    wps = false
  }
}

test_data.wlan2_clients = {}

test_data.wlan0_iwinfo = {
  phy = "phy0",
  ssid = "OpenWRT",
  mode = "Client",
  channel = 13,
  txpower = 20,
  country = "00",
  noise = 0,
  frequency = 2472,
  signal = -62
}

test_data.wlan1_iwinfo = {
  phy = "phy1",
  ssid = "ssid",
  mode = "Master",
  channel = 13,
  txpower = 20,
  country = "00",
  noise = 0,
  frequency = 5180,
  signal = -33
}

test_data.wlan2_iwinfo = {
  phy = "phy2",
  ssid = "OpenWRT2",
  mode = "Client",
  channel = nil,
  txpower = 20,
  country = "00",
  noise = 0,
  frequency = 4472,
  signal = -32
}

test_data.mesh0_iwinfo = {
  phy = "phy0",
  ssid = "meshID",
  bssid = "00:00:00:00:00:00",
  country = "00",
  mode = "Mesh Point",
  channel = 11,
  frequency = 2462,
  frequency_offset = 0,
  txpower = 20,
  txpower_offset = 0,
  quality = 43,
  quality_max = 70,
  signal = -67,
  noise = 0,
  bitrate = 6500,
  encryption = {
    enabled = true,
    wpa = {3},
    authentication = {"sae"},
    ciphers = {"ccmp"}
  },
  htmodes = {"HT20", "HT40"},
  hwmodes = {"b", "g", "n"},
  hwmode = "n",
  htmode = "HT20",
  hardware = {id = {5315, 30211, 5315, 30211}, name = "MediaTek MT7603E"}
}

test_data.mesh1_iwinfo = {
  phy = "phy1",
  ssid = "meshID",
  bssid = "00:00:00:00:00:00",
  country = "00",
  mode = "Mesh Point",
  channel = 40,
  frequency = 5200,
  frequency_offset = 0,
  txpower = 20,
  txpower_offset = 0,
  quality = 34,
  quality_max = 70,
  signal = -76,
  noise = -87,
  bitrate = 195100,
  encryption = {
    enabled = true,
    wpa = {3},
    authentication = {"sae"},
    ciphers = {"ccmp"}
  },
  htmodes = {"HT20", "HT40", "VHT20", "VHT40", "VHT80", "VHT80+80", "VHT160"},
  hwmodes = {"ac", "n"},
  hwmode = "ac",
  htmode = "VHT80",
  hardware = {id = {5315, 30229, 30229, 5315}, name = "MediaTek MT7615E"}
}

test_data.mesh0_clients = {
  results = {
    {
      mac = "00:00:00:00:00:00",
      signal = -76,
      signal_avg = -76,
      noise = -87,
      inactive = 0,
      connected_time = 314439,
      thr = 148687,
      authorized = true,
      authenticated = true,
      preamble = "long",
      wme = true,
      mfp = true,
      tdls = false,
      ["mesh llid"] = 0,
      ["mesh plid"] = 0,
      ["mesh plink"] = "ESTAB",
      ["mesh local PS"] = "ACTIVE",
      ["mesh peer PS"] = "ACTIVE",
      ["mesh non-peer PS"] = "ACTIVE",
      rx = {
        drop_misc = 610279,
        packets = 40424675,
        bytes = 280218466,
        ht = false,
        vht = true,
        he = false,
        mhz = 80,
        rate = 195000,
        mcs = 1,
        nss = 3,
        short_gi = true
      },
      tx = {
        failed = 2377,
        retries = 11358818,
        packets = 50325775,
        bytes = 124429140,
        ht = false,
        vht = true,
        he = false,
        mhz = 80,
        rate = 195000,
        mcs = 1,
        nss = 3,
        short_gi = true
      }
    }
  }
}

test_data.mesh1_clients = {
  results = {
    {
      mac = "00:00:00:00:00:00",
      signal = -67,
      signal_avg = -65,
      noise = 0,
      inactive = 6996,
      connected_time = 314507,
      thr = 4500,
      authorized = true,
      authenticated = true,
      preamble = "long",
      wme = true,
      mfp = true,
      tdls = false,
      ["mesh llid"] = 0,
      ["mesh plid"] = 0,
      ["mesh plink"] = "ESTAB",
      ["mesh local PS"] = "ACTIVE",
      ["mesh peer PS"] = "ACTIVE",
      ["mesh non-peer PS"] = "ACTIVE",
      rx = {
        drop_misc = 585666,
        packets = 5533127,
        bytes = 445412093,
        ht = true,
        vht = false,
        he = false,
        mhz = 20,
        rate = 6500,
        mcs = 0,
        ["40mhz"] = false,
        short_gi = false
      },
      tx = {
        failed = 0,
        retries = 5,
        packets = 12,
        bytes = 1173,
        ht = true,
        vht = false,
        mhz = 20,
        rate = 6500,
        mcs = 0,
        ["40mhz"] = false,
        short_gi = false
      }
    }
  }
}

test_data.parsed_clients = {
  {
    aid = 1,
    assoc = true,
    auth = true,
    authorized = true,
    ht = true,
    mac = "98:3b:8f:98:b1:fb",
    mfp = false,
    preauth = false,
    rrm = {0, 0, 0, 0, 0},
    vht = true,
    wds = false,
    wmm = true,
    wps = false
  }, {
    aid = 2,
    assoc = true,
    auth = true,
    authorized = true,
    ht = true,
    mac = "20:a6:0c:b2:da:10",
    mfp = false,
    preauth = false,
    rrm = {0, 0, 0, 0, 0},
    vht = true,
    wds = false,
    wmm = true,
    wps = false
  }
}

test_data.mesh0_parsed_clients = {
  {
    auth = true,
    authorized = true,
    he = false,
    ht = false,
    mac = "00:00:00:00:00:00",
    mesh_llid = 0,
    mesh_local_ps = "ACTIVE",
    mesh_non_peer_ps = "ACTIVE",
    mesh_peer_ps = "ACTIVE",
    mesh_plid = 0,
    mesh_plink = "ESTAB",
    mfp = true,
    noise = -87,
    signal = -76,
    signal_avg = -76,
    throughput = 148687000,
    vht = true,
    wmm = true
  }
}

test_data.mesh1_parsed_clients = {
  {
    auth = true,
    authorized = true,
    he = false,
    ht = true,
    mac = "00:00:00:00:00:00",
    mesh_llid = 0,
    mesh_local_ps = "ACTIVE",
    mesh_non_peer_ps = "ACTIVE",
    mesh_peer_ps = "ACTIVE",
    mesh_plid = 0,
    mesh_plink = "ESTAB",
    mfp = true,
    noise = 0,
    signal = -67,
    signal_avg = -65,
    throughput = 4500000,
    vht = false,
    wmm = true
  }
}

test_data.wlan0_interface = {
  mac = "00:00:00:00:00:00",
  mtu = 1500,
  multicast = true,
  name = "wlan0",
  txqueuelen = 1000,
  type = "wireless",
  up = true,
  wireless = {
    channel = 13,
    country = "00",
    frequency = 2472,
    mode = "station",
    noise = 0,
    signal = -62,
    ssid = "OpenWRT",
    tx_power = 20
  }
}

test_data.wlan1_interface = {
  mac = "00:00:00:00:00:00",
  mtu = 1500,
  multicast = true,
  name = "wlan1",
  txqueuelen = 1000,
  type = "wireless",
  up = true,
  wireless = {
    channel = 13,
    country = "00",
    frequency = 5180,
    mode = "access_point",
    noise = 0,
    signal = -33,
    ssid = "ssid",
    tx_power = 20
  }
}

test_data.wlan2_interface = {
  mac = "00:00:00:00:00:00",
  mtu = 1500,
  multicast = true,
  name = "wlan2",
  txqueuelen = 1000,
  type = "wireless",
  up = true,
  wireless = {
    channel = nil,
    country = "00",
    frequency = 4472,
    mode = "station",
    noise = 0,
    signal = -32,
    ssid = "OpenWRT2",
    tx_power = 20
  }
}

return test_data
