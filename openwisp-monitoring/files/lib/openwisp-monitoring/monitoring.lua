package.path = package.path .. ";../files/lib/?.lua"

local monitoring = {}

monitoring.dhcp = require('openwisp-monitoring.dhcp')
monitoring.interfaces = require('openwisp-monitoring.interfaces')
monitoring.neighbors = require('openwisp-monitoring.neighbors')
monitoring.resources = require('openwisp-monitoring.resources')
monitoring.utils = require('openwisp-monitoring.utils')
monitoring.wifi = require('openwisp-monitoring.wifi')

return monitoring
