
config = require './config'
saveMeasure = require './saveMeasure'

dbDriver = require '../../openbeelab-db-util/javascript/dbDriver'
dbServer = dbDriver.connectToServer(dbConfig.database)
configDb = dbServer.useDb(config.database.name + "_config")
dataDb = dbServer.useDb(config.database.name + "_data")

weight = 0 #todo read 3rd argument

configDb.get config.stand_id
.then (stand) ->
        
    measure =
        type : 'measure'
        name : 'global-weight'
        value : weight
        unit : 'Kg'
        measureOrigin : "manual"
        timestamp : new Date()
        location_id : stand.location_id
        beehouse_id : stand.beehouse_id
        stand_id : stand._id

    saveMeasure(measure,dataDb)

.catch (err)->

    console.log err
