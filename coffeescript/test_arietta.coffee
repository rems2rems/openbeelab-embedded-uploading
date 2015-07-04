
arietta = require 'aria_fox_gpio'

Output = arietta({model: 'aria',debug: true}).OutGpio

led = new Output 'J4', 34, ()->
    
    #use callback to handle the init
    console.log('init callback button #1')

    isOn = false
    setInterval ()->
        isOn = !isOn
        if (isOn)
            led.setHigh()
        else
            led.setLow()
    , 500

#attach the init event fired (after the callback) when the led is ready 
led.attach 'init', (event)->
    console.log('init event button #1')

#attach the rising event fired when the led is turned on
led.attach 'rising', (event)->
    console.log('led is turned on')

#attach the rising event fired when the led is turned off
led.attach 'falling', (event)->
    console.log('led is turned off')