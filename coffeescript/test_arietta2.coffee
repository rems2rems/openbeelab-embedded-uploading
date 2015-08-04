#test

sensor =
    device : "arietta_g25"
    measureType : 'analogRead'
    pinName : "in_voltage0_raw"

ledPlus =
    device : "arietta_g25"
    measureType : 'digitalWrite'
    direction : "out"
    pinName : "pioB14"
    value : 1

ledGround =
    device : "arietta_g25"
    measureType : 'digitalWrite'
    direction : "out"
    pinName : "pioB13"
    value : 0

device = require './devices/' + sensor.device

device.use(sensor).then (value)->

    console.log "value:" + value

    device.use(ledPlus, ledPlus.value).then ->
        device.use(ledGround, ledGround.value).then ->

            device.use(sensor).then (value)->

                console.log "value:" + value

.catch (err)->
    console.log err