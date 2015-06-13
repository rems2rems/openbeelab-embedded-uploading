
dbDriver = require '../../dbUtil/javascript/dbUtil'
dbConfig = require './config'
db = dbDriver.database(dbConfig)
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

    if dbConfig.external_sites? and dbConfig.external_sites.length > 0
        for external_site in dbConfig.external_sites

            getExternalData = require('./'+external_site)

            getExternalData location,(name,data)->

                insert_external_measure db,location,apiary._id,name,data, ->

                    console.log "external measure ("+external_site+") uploaded to db " + dbConfig.db