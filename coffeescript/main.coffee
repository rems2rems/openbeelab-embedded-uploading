
dbDriver = require '../../openbeelab-db-util/javascript/dbUtil'
config = require './config'

db = dbDriver.database(config)

insert_measure = require './insert_measure'

#standUrl = '_design/stands/_view/by_name?key="'+config.stand_name+'"'
db.get config.stand_id #standUrl
.then (stand) ->
    
    # stand = stand[0].value
    
    device = require './devices/' + stand.device
    
    for sensor in stand.sensors
        
        if not sensor.active
            continue
        
        sensor.device = device
        if device[sensor.process]?

            measure = device[sensor.process]

        else
            
            specificProcess = require './' + sensor.process
            measure = specificProcess(sensor,device)[sensor.action]

        value = measure(sensor,device)

        console.log value

        measure =
            timestamp : new Date()
            location_id : stand.location_id
            beehouse_id : stand.beehouse_id
            type : 'measure'
            name : sensor.name
            raw_value : value
            value : (value-sensor.bias)*sensor.gain
            unit : sensor.unit

        db.save(measure).then ->

            console.log "measure uploaded to db " + config.name

    if stand.sleepMode is on and device.planWakeup and device.shutdown
        device.planWakeup(10)
        console.log "system will reboot 10 seconds after shutdown"
        device.shutdown()
        console.log "system is going to shutdown..."
        
.catch (err)->

    console.log err 