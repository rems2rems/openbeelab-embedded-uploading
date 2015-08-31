
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
            value : value
            unit : sensor.unit

        db.save(measure).then ->

            console.log "measure uploaded to db " + config.name
        
.catch (err)->

    console.log err 
