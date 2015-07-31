pcduino = require 'pcduino'
Promise = require 'promise'

api = 
    use : (sensor) ->

        return @[sensor.measureType](sensor.pin)

    digitalRead : (pin) ->

    	return Promise.resolve pcduino.digital.read(pin)

    digitalWrite : (pin,value) ->

        return Promise.resolve pcduino.digital.write(pin,value)

    analogRead : (pin,callback) ->

        return Promise.resolve pcduino.analog.read(pin)

    pwm : (value) ->

    	#todo



module.exports = api