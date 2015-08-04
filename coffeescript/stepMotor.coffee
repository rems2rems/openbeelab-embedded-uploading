require('../../openbeelab-util/javascript/arrayUtils').install()
require('../../openbeelab-util/javascript/numberUtils').install()
Promise = require 'promise'

module.exports = (directionPin,pulsePin) ->

    return {
        directionPin : directionPin
        pulsePin : pulsePin
        forward  : (nbSteps) -> @move(nbSteps,true)
        backward : (nbSteps) -> @move(nbSteps,false)
        move : (nbSteps,goForward) ->

            if goForward is null
                goForward = nbSteps > 0

            if goForward
                direction = "1"
            else
                direction = "0"
            
            @directionPin.setValue(direction).then =>

                promise = Promise.resolve()
                nbSteps.times =>

                    promise = promise.then => 
                        
                        @pulsePin.setOn().then => 
                            @pulsePin.setOff()

                return promise
    }