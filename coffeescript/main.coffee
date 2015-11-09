
dbDriver = require '../../openbeelab-db-util/javascript/dbUtil'
config = require './config'

db = dbDriver.database(config)

insert_measure = require './insert_measure'

# db.exists()
# .then (db)->
#     console.log db
# .catch (err)->
#     console.log err

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

        db.save(measure).then (result)->

            console.log "measure uploaded to db " + config.name
            try
                add_server_timestamp = 
                    _id : "_design/updates/_update/time/" + result._id
                
                db.save(add_server_timestamp)
                .then ->
                    console.log "added server timestamp to measure " + result._id

.catch (err)->

    console.log err 