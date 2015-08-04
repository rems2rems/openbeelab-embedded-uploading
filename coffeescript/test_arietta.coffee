Pin = require './pin'
#device = require './devices/arietta_g25'
device = require './devices/mock_device'

b14 = device.getGpioExportedName(46)
console.log "should be pioB14:" + b14
directionPin = Pin.buildGpio(device,46)
directionPin.setOutput()
pulsePin = Pin.buildGpio(device,"pioB13")
pulsePin.setOutput()

StepMotor = require('./stepMotor')

motor = StepMotor(directionPin,pulsePin)

motor.forward(100)
motor.backward(100)

searchEquilibrium = require 'romanScale'

photoDiode    = Pin.buildAdc(device,"in_voltage0_raw")

searchEquilibrium = require './romanScale'
promise = searchEquilibrium(motor,photoDiode)

promise.then (nbSteps)->

    console.log "nb steps to equilibrium:" + nbSteps