require('../../openbeelab-util/javascript/arrayUtils').install()
Promise = require 'promise'

move =  (direction,nbSteps) ->

    directionPin.setValue(direction).then ->

        promise = Promise.resolve()
        nbSteps.times ->

            promise = promise.then -> 
                pulsePin.setOn().then -> 
                    pulsePin.setOff()

        return promise

module.exports = (directionPin,pulsePin) ->

    return {
        forward  : (nbSteps) -> move(true ,nbSteps)
        backward : (nbSteps) -> move(false,nbSteps)
    }