module.exports = (measure,dataDb)->

    dataDb.save(measure)
    .then (result)->

        console.log "measure uploaded to db " + dataDbOptions.name
        console.log "measure id:" + result._id
        
        dataDb.save({ _id : "_design/updates/_update/time/" + result._id })

    .then () ->
            
        console.log "added server timestamp"
