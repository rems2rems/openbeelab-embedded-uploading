
config = require './config'
takeMeasure = require './takeMeasure'
saveMeasure = require './saveMeasure'

dbDriver = require '../../openbeelab-db-util/javascript/dbDriver'
configDb = dbDriver.connectToServer(dbConfig.database).useDb(config.database.name + "_config")
dataDb = dbDriver.connectToServer(dbConfig.database).useDb(config.database.name + "_data")

configDb.get config.stand_id
.then (stand) ->
    
    device = require './devices/' + stand.device
    
    for sensor in stand.sensors when sensor.active
                
        sensor.device = device
        
        measure = takeMeasure(sensor)
        
        measure.location_id = stand.location._id
        
        if stand.beehouse._id?
            measure.beehouse_id = stand.beehouse._id
        
        measure.stand_id = stand._id

        saveMeasure(measure,dataDb)

.catch (err)->

    console.log err
