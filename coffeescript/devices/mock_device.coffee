#sh = require('execSync')

prompt = require 'prompt'

nodeFs = require 'fs'
Promise = require 'promise'
fs = 
    readFile : Promise.denodeify nodeFs.readFile.bind(nodeFs)
    writeFile : Promise.denodeify nodeFs.writeFile.bind(nodeFs)

api =

    export : (kernelId)->

        return Promise.resolve "ok"

    unexport : (kernelId)->

        return Promise.resolve "ok"
    
    getDirection : (kernelId) ->

        return Promise.resolve "in"

    setDirection : (kernelId,direction)->

        return Promise.resolve "ok"

    setInputMode : (kernelId)->

        @setDirection @getGpioExportedName(kernelId),"in"

    setOutputMode : (kernelId)->

        @setDirection @getGpioExportedName(kernelId),"out"    

    digitalRead : (pin) ->

        return new Promise((fulfill,reject)->

            console.log "pin " + @getGpioExportedName(pin)
            prompt.start()
            prompt.get ['gpio_value'],(err,result)->

                if(err)
                    reject(err)

                fulfill(result.gpio_value == "1")
        )

    digitalWrite : (pin,value) ->

        return Promise.resolve "ok"

    analogRead : (pin) ->

        return new Promise((fulfill,reject)->

            console.log "pin " + pin
            prompt.start()
            prompt.get ['adc_value'],(err,result)->

                if(err)
                    reject(err)

                fulfill result.adc_value.toInt()
        )

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
