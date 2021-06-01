local monitoring = {}

monitoring.dhcp = require('dhcp')
monitoring.interfaces = require('interfaces')
monitoring.neighbors = require('neighbors')
monitoring.resources = require('resources')
monitoring.utils = require('monitoring_utils')
monitoring.wifi = require('wifi')

return monitoring
