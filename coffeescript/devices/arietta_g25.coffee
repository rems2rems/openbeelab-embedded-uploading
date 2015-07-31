#sh = require('execSync')
fs = require 'fs'
Promise = require 'promise'

# arietta = require 'aria_fox_gpio'

# Output = arietta({model: 'aria',debug: true}).OutGpio
# Input = arietta({model: 'aria',debug: true}).InGpio

# led = new Output 'J4', 10, ()->
    
#     #use callback to handle the init
#     console.log('init callback button #1')

#     isOn = false
#     setInterval ()->
#         isOn = !isOn
#         if (isOn)
#             led.setHigh()
#         else
#             led.setLow()
#     , 500

# #attach the init event fired (after the callback) when the led is ready 
# led.attach 'init', (event)->
#     console.log('init event button #1')

# #attach the rising event fired when the led is turned on
# led.attach 'rising', (event)->
#     console.log('led is turned on')

# #attach the rising event fired when the led is turned off
# led.attach 'falling', (event)->
#     console.log('led is turned off')


# button = new Input 'J4', 10

api =

    use : (sensor) ->

        return @[sensor.measureType](sensor.pin)

    digitalRead : (pin) ->

        return new Promise( (fulfill, reject)->

            pinFile = "pin file..." + pin
            fs.readFile adcFile, (err, data) ->
                if (err) 
                    throw err

                state = if data == 0 then "low" else "high"
                fulfill(state)
        )

    digitalWrite : (pin,value) ->

        # command = 'python /home/ubuntu/openbeelab/openbeelab-embedded-uploading/write.py ' + pin
        # result = sh.exec(command)
        # value = parseInt(result.stdout)
        # return value

    analogRead : (pin) ->
        console.log "read!"
        return new Promise( (fulfill, reject)->

            #de 0 a 2013
            adcFile = "/sys/bus/iio/devices/iio:device0/in_voltage0_raw"
            fs.readFile adcFile, (err, data) ->
                console.log "read ok"
                if (err) 
                    reject(err)
                console.log "data:" + data
                fulfill(data)
        )
        

        # command = 'python /home/ubuntu/openbeelab/openbeelab-embedded-uploading/arietta_readadc.py ' + sensor.pin
        # result = sh.exec(command)
        # value = parseInt(result.stdout)
        # return value

    planWakeup : (seconds) ->

        command = 'echo "+ ' + seconds + '" > /sys/class/rtc/rtc0/wakealarm'
        sh.exec(command)
        
    sleep : () ->

        sh.exec("halt")

module.exports = api
