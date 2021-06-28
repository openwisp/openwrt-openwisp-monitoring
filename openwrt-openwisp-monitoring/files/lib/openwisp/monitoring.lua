package.path = package.path .. ";../files/lib/?.lua"

local monitoring = {}

monitoring.dhcp = require('openwisp.dhcp')
monitoring.interfaces = require('openwisp.interfaces')
monitoring.neighbors = require('openwisp.neighbors')
monitoring.resources = require('openwisp.resources')
monitoring.utils = require('openwisp.monitoring_utils')
monitoring.wifi = require('openwisp.wifi')

return monitoring
