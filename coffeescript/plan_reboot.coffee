
# device = require './devices/arietta_g25'
# device.planWakeup(process.argv[2])
# console.log "system will reboot " + process.argv[2] + " seconds after shutdown"
# device.shutdown()
# console.log "system is going to shutdown..."


dbDriver = require '../../openbeelab-db-util/javascript/dbUtil'
config = require './config'

db = dbDriver.database(config)

db.get config.stand_id
.then (stand) ->
    
    device = require './devices/' + stand.device
    
    if stand.sleepMode is on and device.planWakeup and device.shutdown
        device.planWakeup(stand.sleepDuration)
        console.log "system will reboot 10 seconds after shutdown"
        device.shutdown()
        console.log "system is going to shutdown..."
        
.catch (err)->

    console.log err 