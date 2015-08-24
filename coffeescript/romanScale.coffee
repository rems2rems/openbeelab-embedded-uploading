Promise = require 'promise'
PidController = require('node-pid-controller')
require('../../openbeelab-util/javascript/numberUtils').install()
Pin = require './pin'
StepMotor = require('./stepMotor')

sleep = require('../../openbeelab-util/javascript/timeUtils').sleep

_searchEquilibrium = (motor,photoDiode1,photoDiode2,pid)->

    console.log "searching equilibrium..."

    deltaLight = photoDiode1.getValue() - photoDiode2.getValue()
    
    command  = pid.update(deltaLight).floor()
    
    motor.move(command)
    
    goalIsReached = (command < 5)
    
    if goalIsReached
        return command

    #sleep(200)
    return command + _searchEquilibrium(motor,photoDiode1,photoDiode2,pid)
        


module.exports = (sensor,device)->

    motor = StepMotor(device,sensor.motor)

    photoDiode1 = Pin.buildAdc(device,sensor.photoDiode1)
    photoDiode2 = Pin.buildAdc(device,sensor.photoDiode2)
 
    pid = new PidController(0.25, 0.01, 0.01, 1); # k_p, k_i, k_d, dt 
    pid.setTarget(sensor.deltaTarget)
    nbSteps = 0
    
    return {

        searchEquilibrium : ->
       
            return _searchEquilibrium(motor,photoDiode1,photoDiode2,pid)
    }

# rechercheEquilibre = () ->

#     unsigned long lastMotorAction = millis()
#     prevMotorDirection = 3

#     period = periodFast
#     Timer1.initialize(period)

#     until motorIsStopped

#         opticalLoop()

#         if ((abs(optDiff) > 800) || (abs(diffCC) > 20))
#             if (abs(optDiff) > 800)
#                 Timer1.initialize(periodFast)
#                 motorDirection = optDiff < 0 ? -1 : 1
#             else
#                 motorDirection = diffCC < 0 ? -1 : 1
#                 if (abs(diffCC) > 300) 
#                     Timer1.initialize(periodSlow)     
#                 else 
#                     Timer1.initialize(periodSuperSlow)

#             lastMotorAction = millis()
#         else
#             motorDirection = 0
#         if ((millis() - lastMotorAction) > 4000)
#             motorIsStopped = true

# opticalLoop = () ->
  
#     v0 = analogRead(A0)
#     v1 = analogRead(A1)

#     optDiff = v1 - v0


#     if (diffSens == 1)
#         if (optDiff < diffPrev)
#             diffLowPass ++
#         else 
#             diffLowPass = 0

#         if (optDiff > diffMaxBuf)
#             diffMaxBuf = optDiff

#         if (diffLowPass > 2)
#             diffMinBuf = optDiff
#             diffMax = diffMaxBuf
#             diffSens = -1
#             diffLastMax = millis()
#     else
#         if (optDiff > diffPrev) 
#             diffLowPass ++
#         else 
#             diffLowPass = 0 

#         if (optDiff < diffMinBuf) 
#             diffMinBuf = optDiff

#         if (diffLowPass > 2)
#           diffMaxBuf = optDiff
#           diffMin = diffMinBuf
#           diffSens = 1 
#           diffLastMin = millis()

#     diffPrev = optDiff


#     if (((millis() - diffLastMin) > 4000) || ((millis() - diffLastMax) > 4000))
#         diffCC = optDiff
#     else   
#         diffCC = (diffMax + diffMin) / 2