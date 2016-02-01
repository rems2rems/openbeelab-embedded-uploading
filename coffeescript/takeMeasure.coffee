module.exports =

    (sensor)->

        device = sensor.device

        measure =
            type : 'measure'
            name : sensor.name
            raw_value : value
            value : (value-sensor.bias)*sensor.gain
            unit : sensor.unit
            measureOrigin : "automatic"

        if sensor.isRelative?

            measure.absoluteSource = null

        if device[sensor.process]?

            takeMeasure = device[sensor.process]

        else
            
            specificProcess = require './' + sensor.process
            takeMeasure = specificProcess(sensor,device)[sensor.action]

        value = takeMeasure(sensor,device)

        console.log("measure:" + value)

        measure.raw_value = value
        measure.value = (value-sensor.bias)*sensor.gain
        measure.timestamp = new Date()

        return measure
