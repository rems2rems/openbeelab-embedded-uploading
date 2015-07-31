
arietta = require './devices/arietta_g25'

sensor =
    measureType : 'analogRead'


#loop
arietta.use(sensor).then((value)-> console.log "value:" + value)