
require('../../../openbeelab-util/javascript/arrayUtils').install()

values = {}

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

        if not values[pin]?
            values[pin] = [on,off].pickRandom()

        return values[pin]

    digitalWrite : (pin,value) ->


        if pin is 'J4.28'
            dir = if values['J4.30'] then 1 else -1
            values['in_voltage0_raw'] -=  20*dir
            values['in_voltage1_raw'] +=  20*dir

        return values[pin] = value

    analogWrite : (pin,value) ->

        return values[pin] = value

    analogRead : (pin) ->

        if not values[pin]?
            values[pin] =  [0..1023].pickRandom()


        return values[pin]


module.exports = api