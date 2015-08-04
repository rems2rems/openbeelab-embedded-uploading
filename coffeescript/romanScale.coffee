Promise = require 'promise'
PidController = require('node-pid-controller')

_searchEquilibrium = (motor,photoDiode,pid,nbSteps,fulfill,reject)->

    photoDiode.getValue()
    .then (light)->
        command  = pid.update(light).toInt()
        motor.move(command)
        .then ->
            nbSteps += command
            goalIsReached = (command < 5)
            if not goalIsReached
                setTimeout( ( -> _searchEquilibrium(motor,photoDiode,pid,nbSteps,fulfill,reject)),50)
            else
                fulfill(nbSteps)
        .catch reject
    .catch reject

module.exports = searchEquilibrium = (sensor,device)->
#(motor,photoDiode) ->
    

    Pin = require './pin'
    
    directionName = device.getGpioExportedName(sensor.motor.directionPinId)
    directionPin = Pin.buildGpio(device,directionName)
    directionPin.setOutputMode()

    pulseName = device.getGpioExportedName(sensor.motor.pulsePinId)
    pulsePin = Pin.buildGpio(device,pulseName)
    pulsePin.setOutputMode()

    StepMotor = require('./stepMotor')

    motor = StepMotor(directionPin,pulsePin)

    photoDiode = Pin.buildAdc(device,sensor.photoDiode.pinId)

    equilibrium = new Promise((fulfill,reject)->
        
        pid = new PidController() #0.25, 0.01, 0.01, 1); # k_p, k_i, k_d, dt 
        pid.setTarget(512)
        nbSteps = 0
        
        _searchEquilibrium(motor,photoDiode,pid,nbSteps,fulfill,reject)

    )
    return equilibrium

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