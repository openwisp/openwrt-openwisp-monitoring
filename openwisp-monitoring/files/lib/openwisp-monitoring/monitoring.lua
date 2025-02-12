package.path = package.path .. ";../files/lib/?.lua"

local monitoring = {}

monitoring.dhcp = require('openwisp-monitoring.dhcp')
monitoring.interfaces = require('openwisp-monitoring.interfaces')
monitoring.neighbors = require('openwisp-monitoring.neighbors')
monitoring.resources = require('openwisp-monitoring.resources')
monitoring.utils = require('openwisp-monitoring.utils')
monitoring.wifi = require('openwisp-monitoring.wifi')

local success, iwinfo = pcall(require, 'openwisp-monitoring.iwinfo')
if success then
  monitoring.iwinfo = iwinfo
else
  monitoring.iwinfo = {
    enabled = false
  }
end

return monitoring
