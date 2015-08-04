#sh = require('execSync')
nodeFs = require 'fs'
Promise = require 'promise'
fs = 
    readFile : Promise.denodeify nodeFs.readFile.bind(nodeFs)
    writeFile : Promise.denodeify nodeFs.writeFile.bind(nodeFs)

api =

    export : (kernelId)->

        fs.writeFile("/sys/class/gpio/export",kernelId)

    unexport : (kernelId)->

        fs.writeFile("/sys/class/gpio/unexport",kernelId)
    
    getDirection : (kernelId) ->

        return fs.readFile("/sys/class/gpio/" + @getGpioExportedName(kernelId) + "/direction")

    setDirection : (kernelId,direction)->

        fs.writeFile "sys/class/gpio/" + @getGpioExportedName(kernelId) + "/direction",direction

    setInputMode : (kernelId)->

        @setDirection @getGpioExportedName(kernelId),"in"

    setOutputMode : (kernelId)->

        @setDirection @getGpioExportedName(kernelId),"out"    

    digitalRead : (kernelId) ->

        return fs.readFile("/sys/class/gpio/" + @getGpioExportedName(kernelId) + "/value")

    digitalWrite : (kernelId,value) ->

        return fs.writeFile("/sys/class/gpio/" + @getGpioExportedName(kernelId) + "/value",value)

    analogRead : (adcName) ->

        return fs.readFile "/sys/bus/iio/devices/iio:device0/" + adcName

    planWakeup : (seconds) ->

        return fs.writeFile "/sys/class/rtc/rtc0/wakealarm",seconds

    sleep : () ->

        sh.exec("halt")

    getGpioExportedName : (kernelId)->
        
        if kernelId < 32 or kernelId > 127
            throw new Error('kernelId ' + kernelId + ' not allowed')

        pinName = "pio"
        if (kernelId >= 32 && kernelId <= 63)
            pinName = pinName + 'A' + (kernelId - 32)
        if (kernelId >= 64 && kernelId <= 95)
            pinName = pinName + 'B' + (kernelId - 64)
        if (kernelId >= 96 && kernelId <= 127)
            pinName = pinName + 'C' + (kernelId - 96)
        
        return pinName

module.exports = api
