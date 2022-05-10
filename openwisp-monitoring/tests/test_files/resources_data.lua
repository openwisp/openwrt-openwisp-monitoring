local test_data = {}

test_data.disk_usage = {
  {
    available_bytes = 239476736,
    filesystem = "/dev/root",
    mount_point = "/",
    size_bytes = 264208384,
    used_bytes = 19365888,
    used_percent = 7
  }, {
    available_bytes = 12201984,
    filesystem = "/dev/sda1",
    mount_point = "/boot",
    size_bytes = 16498688,
    used_bytes = 3964928,
    used_percent = 25
  }, {
    available_bytes = 12201984,
    filesystem = "/dev/sda1",
    mount_point = "/boot",
    size_bytes = 16498688,
    used_bytes = 3964928,
    used_percent = 25
  }
}

return test_data
