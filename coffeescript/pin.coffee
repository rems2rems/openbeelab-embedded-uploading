
module.exports =

    buildGpio : (device,pinId,pinName) ->

        device.export pinId

        return {

            setInputMode : =>
                device.setInputMode(pinName) #.then =>
                return @
            setOutputMode : =>
                device.setOutputMode(pinName) #.then =>
                return @
            isOn : -> device.digitalRead(pinName) is "1" #.then (value)-> return value
            isOff : -> @isOn().then (value) -> return not value
            getValue : -> device.digitalRead(pinName)
            setValue : (value)->
                if value == true
                    value = "1"
                if value == false
                    value = "0"
                
                device.digitalWrite(pinName,value)
            setOn : -> @setValue(on)
            setOff : -> @setValue(off)
            unexport : -> device.unexport pinId
        }

    buildAdc : (device,pinName) ->

        return {

            getValue : -> device.analogRead(pinName)
        }