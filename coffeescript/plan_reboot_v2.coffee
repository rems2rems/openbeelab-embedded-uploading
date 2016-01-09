
console.log "executing plan_reboot.js..."

dbDriver = require '../../openbeelab-db-util/javascript/dbUtil'
config = require './config'
config.name = config.name + "_config"

db = dbDriver.database(config)

db.get config.stand_id
.then (stand) ->
    
    device = require './devices/' + stand.device 
    return [stand.sleepMode is on and device.planWakeup and device.shutdown,stand.sleepDuration,device]
        
.catch (err)->

    console.log "error while fetching sleep infos in db:"
    console.log err
    device = null
    try
        device = require './devices/arietta_g25'
    finally
        return [true,3300,device]

.finally ([sleepMode,sleepDuration,device])->

    if sleepMode and device?

        device.planWakeup(sleepDuration)
        console.log "system will reboot " + sleepDuration + " seconds after shutdown"
        device.shutdown()
        console.log "system is going to shutdown..."
