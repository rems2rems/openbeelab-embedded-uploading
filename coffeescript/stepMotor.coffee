require('../../openbeelab-util/javascript/arrayUtils').install()
require('../../openbeelab-util/javascript/numberUtils').install()
Promise = require 'promise'

sleep = (time, callback)->

    stop = new Date().getTime()
    while (new Date().getTime() < stop + time)
        ;
    
    callback?()

module.exports = (directionPin,pulsePin) ->

    return {
        directionPin : directionPin
        pulsePin : pulsePin
        forward  : (nbSteps) -> @move(nbSteps,true)
        backward : (nbSteps) -> @move(nbSteps,false)
        move : (nbSteps,goForward) ->

            if goForward is null
                goForward = nbSteps > 0
            
            nbSteps = nbSteps.abs()

            if goForward
                direction = "1"
            else
                direction = "0"
            
            @directionPin.setValue(direction) #.then =>

                # promise = Promise.resolve()
            nbSteps.times =>

                # promise = promise.then => 
                    
                @pulsePin.setOn() #.then => 
                sleep(100)
                @pulsePin.setOff()
                sleep(100)

            return promise
    }