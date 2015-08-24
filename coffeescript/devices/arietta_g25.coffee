sh = require('execSync')

#nodeFs = require 'fs'
#Promise = require 'promise'
#fs = 
#    readFile : Promise.denodeify nodeFs.readFile.bind(nodeFs)
#    writeFile : Promise.denodeify nodeFs.writeFile.bind(nodeFs)

pin2name =

    'J4.7'  : 'PA23'
    'J4.8'  : 'PA22'
    'J4.10' : 'PA21'
    'J4.11' : 'PA24'
    'J4.12' : 'PA31'
    'J4.13' : 'PA25'
    'J4.14' : 'PA30'
    'J4.15' : 'PA26'
    'J4.17' : 'PA27'
    'J4.19' : 'PA28'
    'J4.21' : 'PA29'
    'J4.23' : 'PA0' 
    'J4.24' : 'PA1' 
    'J4.25' : 'PA8' 
    'J4.26' : 'PA7' 
    'J4.27' : 'PA6' 
    'J4.28' : 'PA5' 
    'J4.29' : 'PC28'
    'J4.30' : 'PC27'
    'J4.31' : 'PC4' 
    'J4.32' : 'PC31'
    'J4.33' : 'PC3' 
    'J4.34' : 'PB11'
    'J4.35' : 'PC2' 
    'J4.36' : 'PB12'
    'J4.37' : 'PC1' 
    'J4.38' : 'PB13'
    'J4.39' : 'PC0' 
    'J4.40' : 'PB14'

pin2kid =

    'J4.7'   :  55, #PA23
    'J4.8'   :  54, #PA22
    'J4.10'  :  53, #PA21
    'J4.11'  :  56, #PA24
    'J4.12'  :  63, #PA31
    'J4.13'  :  57, #PA25
    'J4.14'  :  62, #PA30
    'J4.15'  :  58, #PA26
    'J4.17'  :  59, #PA27
    'J4.19'  :  60, #PA28
    'J4.21'  :  61, #PA29
    'J4.23'  :  32, #PA0
    'J4.24'  :  33, #PA1
    'J4.25'  :  40, #PA8
    'J4.26'  :  39, #PA7
    'J4.27'  :  38, #PA6
    'J4.28'  :  37, #PA5
    'J4.29'  : 124, #PC28
    'J4.30'  : 123, #PC27
    'J4.31'  : 100, #PC4
    'J4.32'  : 127, #PC31
    'J4.33'  :  99, #PC3
    'J4.34'  :  75, #PB11
    'J4.35'  :  98, #PC2
    'J4.36'  :  76, #PB12
    'J4.37'  :  97, #PC1
    'J4.38'  :  77, #PB13
    'J4.39'  :  96, #PC0
    'J4.40'  :  78  #PB14

api =

    export : (pinName)->

        return fs.writeFileSync("/sys/class/gpio/export","" + pin2kid[pinName])

    unexport : (pinName)->

        return fs.writeFileSync("/sys/class/gpio/unexport",pin2kid[pinName])
    
    getDirection : (pinName) ->

        return fs.readFileSync("/sys/class/gpio/" + pin2name[pinName] + "/direction")

    setDirection : (pinName,direction)->

        fs.writeFileSync "sys/class/gpio/" + pin2name[pinName] + "/direction",direction

    setInputMode : (pinName)->

        @setDirection pinName,"in"

    setOutputMode : (pinName)->

        @setDirection pinName,"out"    

    digitalRead : (pinName) ->
        value = fs.readFileSync("/sys/class/gpio/" + pin2name[pinName] + "/value")
        if value is "0"
            return off
        return on

    digitalWrite : (pinName,value) ->
        if value is on
            value = "1"
        if value is off
            value = "0"
        return fs.writeFileSync("/sys/class/gpio/" + pin2name[pinName] + "/value",value)

    analogRead : (adcName) ->

        return fs.readFileSync("/sys/bus/iio/devices/iio:device0/" + adcName).toInt()

    planWakeup : (seconds) ->

        return fs.writeFileSync("/sys/class/rtc/rtc0/wakealarm","" + seconds)

    sleep : () ->

        sh.exec("halt")

    # getGpioExportedName : (kernelId)->
        
    #     if kernelId < 32 or kernelId > 127
    #         throw new Error('kernelId ' + kernelId + ' not allowed')

    #     pinName = "pio"
    #     # if (kernelId >= 32 && kernelId <= 63)
    #     #     pinName = pinName + 'A' + (kernelId - 32)
    #     if (kernelId >= 64 && kernelId <= 95)
    #         pinName = pinName + 'A' + (kernelId - 64)
    #     if (kernelId >= 96 && kernelId <= 127)
    #         pinName = pinName + 'B' + (kernelId - 96)
        
    #     return pinName

module.exports = api
