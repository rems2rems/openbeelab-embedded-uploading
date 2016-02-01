module.exports =

    (sensor)->

        device = sensor.device

        measure =
            type : 'measure'
            name : sensor.name
            raw_value : value
            value : (value-sensor.bias)*sensor.gain
            unit : sensor.unit
            measureSource : "automatic"

        if sensor.isRelative?

            measure.absolute_ref = null

        if device[sensor.process]?

            makeMeasure = device[sensor.process]

        else
            
            specificProcess = require './' + sensor.process
            makeMeasure = specificProcess(sensor,device)[sensor.action]

        value = makeMeasure(sensor,device)

        console.log("measure:" + value)

        measure.raw_value = value
        measure.value = (value-sensor.bias)*sensor.gain
        measure.timestamp = new Date()

        return measure
