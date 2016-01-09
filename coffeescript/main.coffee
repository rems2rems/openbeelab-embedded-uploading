
dbDriver = require '../../openbeelab-db-util/javascript/dbUtil'
config = require './config'

configDbOptions = 
    host : config.host
    protocol : config.protocol
    port : config.port
    auth:
        username: config.auth.username
        password: config.auth.password
    name : config.name + "_config"

configDb = dbDriver.database(configDbOptions)

dataDbOptions = 
    host : config.host
    protocol : config.protocol
    port : config.port
    auth:
        username: config.auth.username
        password: config.auth.password
    name : config.name + "_data"

dataDb = dbDriver.database(dataDbOptions)

insert_measure = require './insert_measure'

configDb.get config.stand_id
.then (stand) ->
    
    device = require './devices/' + stand.device
    
    for sensor in stand.sensors when sensor.active
                
        sensor.device = device
        if device[sensor.process]?

            measure = device[sensor.process]

        else
            
            specificProcess = require './' + sensor.process
            measure = specificProcess(sensor,device)[sensor.action]

        value = measure(sensor,device)

        console.log("measure:" + value)

        measure =
            timestamp : new Date()
            location : stand.location
            beehouse : stand.beehouse
            stand_id : stand._id
            type : 'measure'
            name : sensor.name
            raw_value : value
            value : (value-sensor.bias)*sensor.gain
            unit : sensor.unit

        dataDb.save(measure).then (result)->

            console.log "measure uploaded to db " + dataDbOptions.name
            console.log "measure id:" + result._id
            
            dataDb.save({ _id : "_design/updates/_update/time/" + result._id })

        .then () ->
                
            console.log "added server timestamp"

.catch (err)->

    console.log err 