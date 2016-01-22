module.exports = (measure,stand,dataDb)->
    measure.location_id = stand.location._id
    measure.beehouse_id = stand.beehouse._id
    measure.stand_id = stand._id

    dataDb.save(measure).then (result)->

        console.log "measure uploaded to db " + dataDbOptions.name
        console.log "measure id:" + result._id
        
        dataDb.save({ _id : "_design/updates/_update/time/" + result._id })

    .then () ->
            
        console.log "added server timestamp"