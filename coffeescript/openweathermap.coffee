
http = require 'http'
#request = require 'request'

module.exports = (location,callback) ->
    #lat=44.849264
    #lon=-0.572434
    url = "http://api.openweathermap.org/data/2.5/weather?lat=" + location.latitude + "&lon=" + location.longitude + "&mode=json&units=metric"
    console.log url
    http.get url,(response)->

        str = ''

        #another chunk of data has been recieved, so append it to `str`
        response.on 'data', (chunk)->
            str += chunk

        #the whole response has been recieved, so we just print it out here
        response.on 'end', ->
            
            data = JSON.parse(str)
            ret = {}
            ret['temp'] = data.main.temp
            ret['pressure'] = data.main.pressure
            ret['humidity'] = data.main.humidity
            ret['wind']  = data.wind

            callback('weather',ret)

