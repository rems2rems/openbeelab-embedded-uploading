dbDriver = require '../../openbeelab-db-util/javascript/dbUtil'
config = require './config'
config.name = config.name + "_config"

db = dbDriver.database(config)

db.get config.stand_id
.then (stand) ->
    
    device = require './devices/' + stand.device
    
    if stand.sleepMode is on and device.planWakeup and device.shutdown
        device.planWakeup(stand.sleepDuration)
        console.log "system will reboot " + stand.sleepDuration + " seconds after shutdown"
        device.shutdown()
        console.log "system is going to shutdown..."
        
.catch (err)->

    console.log err 

    device = require './devices/arietta_g25'
    device.planWakeup(3300)
    console.log "system will reboot 3300 seconds after shutdown"
    device.shutdown()
    console.log "system is going to shutdown..."
