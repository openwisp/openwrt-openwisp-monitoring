local test_data = {}

test_data.wireless_status={
  radio0 = {
    autostart = true,
    config = {
      channel = "11",
      htmode = "HT20",
      hwmode = "11g",
      path = "platform/10300000.wmac"
    },
    disabled = false,
    interfaces = { {
        config = {
          encryption = "none",
          mode = "ap",
          network = { "lan" },
          ssid = "OpenWrt"
        },
        ifname = "wlan0-1",
        section = "default_radio0"
      }, {
        config = {
          encryption = "psk2",
          key = "95535210",
          mode = "sta",
          network = { "wwan" },
          ssid = "DIR-615-5A5B"
        },
        ifname = "wlan0",
        section = "wifinet2"
      } },
    pending = false,
    retry_setup_failed = false,
    up = true
  },
  radio1 = {
    autostart = true,
    config = {
      channel = "36",
      htmode = "VHT80",
      hwmode = "11a",
      path = "pci0000:00/0000:00:00.0/0000:01:00.0"
    },
    disabled = false,
    interfaces = { {
        config = {
          encryption = "none",
          mode = "ap",
          network = { "lan" },
          ssid = "OpenWrt"
        },
        ifname = "wlan1",
        section = "default_radio1"
      } },
    pending = false,
    retry_setup_failed = false,
    up = true
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
      rrm = { 0, 0, 0, 0, 0 },
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
      rrm = { 0, 0, 0, 0, 0 },
      vht = true,
      wds = false,
      wmm = true,
      wps = false
    }
}

test_data.wlan0_clients = {}

test_data.parsed_clients = {
    {
        aid=1,
        assoc=true,
        auth=true,
        authorized=true,
        ht=true,
        mac="98:3b:8f:98:b1:fb",
        mfp=false,
        preauth=false,
        rrm={0, 0, 0, 0, 0},
        vht=true,
        wds=false,
        wmm=true,
        wps=false
    },
    {
        aid=2,
        assoc=true,
        auth=true,
        authorized=true,
        ht=true,
        mac="20:a6:0c:b2:da:10",
        mfp=false,
        preauth=false,
        rrm={0, 0, 0, 0, 0},
        vht=true,
        wds=false,
        wmm=true,
        wps=false
    }
}

return test_data
