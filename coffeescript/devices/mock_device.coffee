Promise = require('promise')

api = 
    use : (sensor) ->

        return @[sensor.measureType](sensor.pin)

    digitalRead : (pin) ->

        return Promise.resolve Math.floor(Math.random()*2)

    digitalWrite : (pin,value) ->

        return Promise.resolve null

    analogRead : (pin) ->

        return Promise.resolve Math.floor(Math.random()*4000)


module.exports = api

module.exports.read = -> 
    