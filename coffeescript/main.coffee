
dbDriver = require '../../dbUtil/javascript/dbUtil'
dbConfig = require './config'
db = dbDriver.database(dbConfig)
acquire_sensor_data = require './acquire_sensor_data'
insert_measure = require './insert_measure'
insert_external_measure = require './insert_external_measure'

Promise = require 'promise'

dbGet = Promise.denodeify db.get.bind(db)

apiary = null
apiaryLocation = null

apiariesUrl = '_design/apiaries/_view/by_name?key="'+ dbConfig.apiary_name+'"'
apiariesPromise = dbGet apiariesUrl
apiariesPromise.then (apiaries) ->

    apiary = apiares[0].value
    return dbGet apiary.location_id

.then (location) ->

    apiaryLocation = location

    beehousesUrl = '_design/beehouses/_view/by_apiary?key="'+apiary._id+'"'
    return dbGet beehousesUrl

.then (beehouses) ->
    
    console.log beehouses
    for beehouse in beehouses
        
        beehouse = beehouse.value

        sensorsUrl = '_design/sensors/_view/by_beehouse?key="'+beehouse._id+'"'
        sensorsPromise = dbGet sensorsUrl
        sensorsPromise.then (sensors) ->

            for sensor in sensors
            
                sensor = sensor.value

                acquire_sensor_data sensor.pin,(value)->

                    console.log value
                    insert_measure db,sensor,apiaryLocation,value, (err,msg)->
                        console.log err
                        console.log msg
                        console.log "measure uploaded to db " + dbConfig.db