
dbDriver = require '../../openbeelab-db-util/javascript/dbUtil'
dbConfig = require './config'

db = dbDriver.database(dbConfig)

insert_measure = require './insert_measure'

apiary = null
apiaryLocation = null

apiariesUrl = '_design/apiaries/_view/by_name?key="'+ dbConfig.apiary_name+'"'
apiariesPromise = db.get apiariesUrl
apiariesPromise
.then (apiaries) ->

    apiary = apiaries[0].value
    return db.get apiary.location_id

.then (location) ->

    apiaryLocation = location
    console.log location
    beehousesUrl = '_design/beehouses/_view/by_apiary?key="'+apiary._id+'"'
    return db.get beehousesUrl

.then (beehouses) ->
    
    console.log beehouses
    for beehouse in beehouses
        
        beehouse = beehouse.value

        sensorsUrl = '_design/sensors/_view/by_beehouse?key="'+beehouse._id+'"'
        sensorsPromise = db.get sensorsUrl
        sensorsPromise.then (sensors) ->

            for sensor in sensors
                
                console.log sensor

                sensor = sensor.value
                device = require './devices/' + sensor["device"]
                measurePromise = device.use(sensor)
                measurePromise.then (value)->

                    console.log value
                    insertPromise = insert_measure db,sensor,apiaryLocation,value
                    insertPromise.then (msg)->
                        console.log msg
                        console.log "measure uploaded to db " + dbConfig.db
        .catch (err)->

            console.log err 
.catch (err)->

    console.log err 