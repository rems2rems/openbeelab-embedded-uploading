
http = require 'http'
#request = require 'request'

module.exports = (location,callback) ->
    
    ret = {}
    ret['temp'] = 16.5
    ret['pressure'] = 1000.4
    ret['humidity'] = 0.7
    ret['wind']  = 80
    callback('weather',ret)

