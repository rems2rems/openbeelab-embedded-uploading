
require('../../../openbeelab-util/javascript/arrayUtils').install()

api =

    export : (kernelId)->

        return "ok"

    unexport : (kernelId)->

        return "ok"
    
    getDirection : (kernelId) ->

        return "in"

    setDirection : (kernelId,direction)->

        return "ok"

    setInputMode : (kernelId)->

        return "ok"

    setOutputMode : (kernelId)->

        return "ok"

    digitalRead : (pin) ->

       return [on,off].pickRandom()

    digitalWrite : (pin,value) ->

        return "ok"

    analogRead : (pin) ->

        [0..1023].pickRandom()

module.exports = api