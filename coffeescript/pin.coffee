
module.exports =

    buildGpio : (device,pinId) ->

        device.export pinId

        return {

            setInputMode : -> device.setInputMode(pinId)
            setOutputMode : -> device.setOutputMode(pinId)
            isOn : -> device.digitalRead(pinId).then (value)-> return value is "1"
            isOff : -> @isOn().then (value) -> return not value
            getValue : -> device.digitalRead(pinId)
            setValue : (value)->
                if value == true
                    value = "1"
                if value == false
                    value = "0"
                
                device.digitalWrite(pinId,value)
            setOn : -> @setValue("1")
            setOff : -> @setValue("0")
            unexport : -> device.unexport pinId
        }

    buildAdc : (device,pinName) ->

        return {

            getValue : -> device.analogRead(pinName)
        }