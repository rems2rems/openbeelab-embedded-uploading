

sensor = 
    device : 'arietta_g25'
    #device : 'mock_device_sync'
    process : 'romanScale'
    action : 'searchEquilibrium'
    motor :
        enable : 'J4.8'
        ms1 : 'J4.10'
        ms2 : 'J4.12'
        ms3 : 'J4.14'
        pulse : 'J4.28'
        direction : 'J4.30'
        sleep : 'J4.26'
        reset : 'J4.24'

    photoDiode1 : 'in_voltage0_raw'
    photoDiode2 : 'in_voltage1_raw'
    ir_diode1 : 'J4.27'
    ir_diode2 : 'J4.29'
    deltaTarget : 0

device = require './devices/' + sensor.device

specificProcess = require './' + sensor.process
measure = specificProcess(sensor,device)[sensor.action]

console.log  measure()