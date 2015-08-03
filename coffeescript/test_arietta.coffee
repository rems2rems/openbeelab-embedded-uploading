Pin = require './pin'
arietta = require './devices/arietta_g25'

directionPin = Pin.buildGpio(arietta,"pioB14")
directionPin.setOutput()
pulsePin = Pin.buildGpio(arietta,"pioB13")
pulsePin.setOutput()

StepMotor = require('./stepMotor')

motor = StepMotor(directionPin,pulsePin)

motor.forward(100)
motor.backward(100)

searchEquilibrium = require 'romanScale'

photoDiodeTop    = Pin.buildAdc(arietta,"in_voltage0_raw")
photoDiodeBottom = Pin.buildAdc(arietta,"in_voltage1_raw")

promise = searchEquilibrium(motor,photoDiodeTop,photoDiodeBottom)

promise.then (nbSteps)->

    console.log "nb steps to equilibrium:" + nbSteps