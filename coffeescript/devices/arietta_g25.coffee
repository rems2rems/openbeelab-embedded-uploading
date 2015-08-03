#sh = require('execSync')
nodeFs = require 'fs'
Promise = require 'promise'
fs = 
    readFile : Promise.denodeify nodeFs.readFile.bind(nodeFs)
    writeFile : Promise.denodeify nodeFs.writeFile.bind(nodeFs)
    
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

    export : (kernelId)->

        fs.writeFile("/sys/class/gpio/export",kernelId)

    teardown : (gpios)->

        for pin in gpios

            fs.writeFile("/sys/class/gpio/unexport",pin.kernelId)
    
    setDirection : (pinName,direction)->

        fs.writeFile "sys/class/gpio/" + pin.name + "/direction",direction

    setInputMode : (pinName)->

        @setDirection pinName,"in"

    setOutputMode : (pinName)->

        @setDirection pinName,"out"    

    use : (sensor) ->

        return @[sensor.measureType](sensor.pinName)

    digitalRead : (pinName) ->

        return fs.readFile("/sys/class/gpio/" + pinName + "/value")

    digitalWrite : (pinName,value) ->

        return fs.writeFile("/sys/class/gpio/" + pinName + "/value",value)

    analogRead : (adcName) ->

        return fs.readFile "/sys/bus/iio/devices/iio:device0/" + adcName

    planWakeup : (seconds) ->

        return fs.writeFile "/sys/class/rtc/rtc0/wakealarm",seconds

    sleep : () ->

        sh.exec("halt")

module.exports = api
