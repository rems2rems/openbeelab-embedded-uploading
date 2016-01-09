
module.exports =

    buildGpio : (device,pinName,direction = "in") ->

        device.export pinName
        device.setDirection(pinName,direction)

        return {

            setInputMode : =>
                device.setInputMode(pinName)
            setOutputMode : =>
                device.setOutputMode(pinName)
            isOn : -> @getValue() is on
            isOff : -> @getValue() is off
            getValue : -> device.digitalRead(pinName)
            setValue : (value)-> device.digitalWrite(pinName,value)
            setOn : -> @setValue(on)
            setOff : -> @setValue(off)
            unexport : -> device.unexport pinName
        }

    buildAdc : (device,pinName) ->

        return {

            getValue : -> device.analogRead(pinName)
        }