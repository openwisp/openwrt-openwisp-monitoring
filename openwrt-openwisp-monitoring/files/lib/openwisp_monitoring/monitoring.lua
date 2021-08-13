package.path = package.path .. ";../files/lib/?.lua"

local monitoring = {}

monitoring.dhcp = require('openwisp_monitoring.dhcp')
monitoring.interfaces = require('openwisp_monitoring.interfaces')
monitoring.neighbors = require('openwisp_monitoring.neighbors')
monitoring.resources = require('openwisp_monitoring.resources')
monitoring.utils = require('openwisp_monitoring.utils')
monitoring.wifi = require('openwisp_monitoring.wifi')

return monitoring
