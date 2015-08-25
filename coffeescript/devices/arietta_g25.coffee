#sh = require('execSync')
fs = require 'fs'

#nodeFs = require 'fs'
#Promise = require 'promise'
#fs = 
#    readFile : Promise.denodeify nodeFs.readFile.bind(nodeFs)
#    writeFile : Promise.denodeify nodeFs.writeFile.bind(nodeFs)

pin2name =

    'J4.7'  : 'pioA23'
    'J4.8'  : 'pioA22'
    'J4.10' : 'pioA21'
    'J4.11' : 'pioA24'
    'J4.12' : 'pioA31'
    'J4.13' : 'pioA25'
    'J4.14' : 'pioA30'
    'J4.15' : 'pioA26'
    'J4.17' : 'pioA27'
    'J4.19' : 'pioA28'
    'J4.21' : 'pioA29'
    'J4.23' : 'pioA0' 
    'J4.24' : 'pioA1' 
    'J4.25' : 'pioA8' 
    'J4.26' : 'pioA7' 
    'J4.27' : 'pioA6' 
    'J4.28' : 'pioA5' 
    'J4.29' : 'pioC28'
    'J4.30' : 'pioC27'
    'J4.31' : 'pioC4' 
    'J4.32' : 'pioC31'
    'J4.33' : 'pioC3' 
    'J4.34' : 'pioB11'
    'J4.35' : 'pioC2' 
    'J4.36' : 'pioB12'
    'J4.37' : 'pioC1' 
    'J4.38' : 'pioB13'
    'J4.39' : 'pioC0' 
    'J4.40' : 'pioB14'

pin2kid =

    'J4.7'   :  23, #PA23
    'J4.8'   :  22, #PA22
    'J4.10'  :  21, #PA21
    'J4.11'  :  24, #PA24
    'J4.12'  :  31, #PA31
    'J4.13'  :  25, #PA25
    'J4.14'  :  30, #PA30
    'J4.15'  :  26, #PA26
    'J4.17'  :  27, #PA27
    'J4.19'  :  28, #PA28
    'J4.21'  :  29, #PA29
    'J4.23'  :  0, #PA0
    'J4.24'  :  1, #PA1
    'J4.25'  :  8, #PA8
    'J4.26'  :  7, #PA7
    'J4.27'  :  6, #PA6
    'J4.28'  :  5, #PA5
    'J4.29'  : 92, #PC28
    'J4.30'  : 91, #PC27
    'J4.31'  : 68, #PC4
    'J4.32'  : 95, #PC31
    'J4.33'  :  67, #PC3
    'J4.34'  :  43, #PB11
    'J4.35'  :  66, #PC2
    'J4.36'  :  44, #PB12
    'J4.37'  :  65, #PC1
    'J4.38'  :  45, #PB13
    'J4.39'  :  64, #PC0
    'J4.40'  :  46  #PB14

api =

    export : (pinName)->

        return fs.writeFileSync("/sys/class/gpio/export","" + pin2kid[pinName])

    unexport : (pinName)->

        return fs.writeFileSync("/sys/class/gpio/unexport",pin2kid[pinName])
    
    getDirection : (pinName) ->

        return fs.readFileSync("/sys/class/gpio/" + pin2name[pinName] + "/direction")

    setDirection : (pinName,direction)->

        fs.writeFileSync "/sys/class/gpio/" + pin2name[pinName] + "/direction",direction

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
