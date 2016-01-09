require('../../openbeelab-util/javascript/numberUtils').install()
Pin = require './pin'
StepMotor = require('./stepMotor')

sleep = require('../../openbeelab-util/javascript/timeUtils').sleep

_searchEquilibrium = (motor,photoDiode1,photoDiode2,pid)->

    console.log "searching equilibrium..."

    light1 = photoDiode1.getValue()
    light2 = photoDiode2.getValue()
    console.log "light1=" + light1
    console.log "light2=" + light2
    deltaLight = light1 - light2
    
    nbSteps = 0

    if light2 > light1
        until deltaLight > 100
            motor.backward()
            nbSteps -= 1
            light1 = photoDiode1.getValue()
            light2 = photoDiode2.getValue()
            console.log("light1=" + light1 "      light2=" + light2)
            deltaLight = light1 - light2

    until deltaLight < 10
        motor.forward()
        sleep(1025 - deltaLight.abs())
        nbSteps += 1
        light1 = photoDiode1.getValue()
        light2 = photoDiode2.getValue()
        console.log("light1=" + light1 "      light2=" + light2)
        deltaLight = light1 - light2

    return nbSteps

module.exports = (sensor,device)->

    motor = StepMotor(device,sensor.motor)

    photoDiode1 = Pin.buildAdc(device,sensor.photoDiode1)
    photoDiode2 = Pin.buildAdc(device,sensor.photoDiode2)
    
    ir_diode1 = Pin.buildGpio(device,sensor.ir_diode1,'out')
    ir_diode2 = Pin.buildGpio(device,sensor.ir_diode2,'out')

    return {

        searchEquilibrium : ->
            
            motor.switchOn()
            ir_diode1.setOn()
            ir_diode2.setOn()
            infos = _searchEquilibrium(motor,photoDiode1,photoDiode2)
            motor.switchOff()
            ir_diode1.setOff()
            ir_diode2.setOff()

            return infos
    }