
dbDriver = require '../../openbeelab-db-util/javascript/dbDriver'
config = require './config'
takeMeasure = require './takeMeasure'
saveMeasure = require './saveMeasure'

configDb = dbDriver.connectToServer(dbConfig.database).useDb(config.database.name + "_config")
dataDb = dbDriver.connectToServer(dbConfig.database).useDb(config.database.name + "_data")

configDb.get config.stand_id
.then (stand) ->
    
    device = require './devices/' + stand.device
    
    for sensor in stand.sensors when sensor.active
                
        sensor.device = device
        
        measure = takeMeasure(sensor)

        saveMeasure(measure,stand,dataDb)

.catch (err)->

    console.log err
