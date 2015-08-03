
module.exports =

    buildGpio : (sensor) ->

        device = sensor.device
        kernelId = sensor.kernelId
        pinName = sensor.pinName

        device.setup [sensor]

        return {

            setInputMode : -> device.setInputMode(pinName)
            setOutputMode : -> device.setOutputMode(pinName)
            isOn : -> device.digitalRead(pinName).then (value)-> return value is "1"
            isOff : -> @isOn().then (value) -> return not value
            getValue : -> device.digitalRead(pinName)
            setValue : (value)->
                if value == true
                    value = "1"
                if value == false
                    value = "0"
                
                device.digitalWrite(pinName,value)
            setOn : -> @setValue("1")
            setOff : -> @setValue("0")
            unexport : -> device.unexport([sensor.kernelId])
        }

    buildAdc : (device,pinName) ->

        return {

            getValue : -> device.analogRead(pinName)
        }