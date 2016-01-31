require('../../../openbeelab-util/javascript/arrayUtils').install()
require('../../../openbeelab-util/javascript/numberUtils').install()
sleep = require('../../../openbeelab-util/javascript/timeUtils').sleep
Pin = require './pin'

module.exports = (device,config) ->

    enable = Pin.buildGpio(device,config.enable,'out') #high pour moteur actif
    ms1 = Pin.buildGpio(device,config.ms1,'out') #microstep 1/2 pas
    ms2 = Pin.buildGpio(device,config.ms2,'out') #microstep 1/4 pas
    ms3 = Pin.buildGpio(device,config.ms3,'out') #microstep 1/16 pas si ms1 et ms2
    pulse = Pin.buildGpio(device,config.pulse,'out') #impulsions
    direction = Pin.buildGpio(device,config.direction,'out') #avant/arriere
    sleepPin = Pin.buildGpio(device,config.sleep,'out') #logique inversée
    reset = Pin.buildGpio(device,config.reset,'out') #logique inversée

    ms1.setOff()
    ms2.setOff()
    ms3.setOff()

    return {

        switchOn : ->

            enable.setOff()
            reset.setOn()
            sleepPin.setOn()

            sleep(1)

        switchOff : ->

            enable.setOn()
            reset.setOff()
            sleepPin.setOff()

        forward  : (nbSteps=1) -> @move(nbSteps)
        backward : (nbSteps=1) -> @move(-1*nbSteps)
        move : (nbSteps=1) ->

            #console.log "moving..."

            goForward = nbSteps > 0
            
            nbSteps = nbSteps.abs()
            
            direction.setValue(goForward)

            nbSteps.times ->
 
                pulse.setOn()
                sleep(config.stepDelay) # ms
                pulse.setOff()
                sleep(config.stepDelay)

            return
    }