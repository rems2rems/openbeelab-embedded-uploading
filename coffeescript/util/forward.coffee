StepMotor = require '../drivers/stepMotor'
#device = require './devices/mock_device_sync'
device = require '../devices/arietta_g25'
#device.unexportAll()

pins =
    enable :'J4.8'
    ms1 : 'J4.10'
    ms2 : 'J4.12'
    ms3 : 'J4.14'
    pulse : 'J4.28'
    direction : 'J4.30'
    sleep : 'J4.26'
    reset : 'J4.24'

motor = StepMotor(device,pins)

loop
    motor.forward(100)