
device = require './devices/arietta_g25'
device.planWakeup(10)
console.log "system will reboot 10 seconds after shutdown"
device.shutdown()
console.log "system is going to shutdown..."