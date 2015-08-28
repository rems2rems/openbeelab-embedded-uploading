
#PidController = require('node-pid-controller')
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
    # si light 1 > light 2   --> tourne +
    # jusqu-à light1 - light 2 < 10
    if light1 > light2
        until light1 - light2 < 10
            motor.forward()
            nbSteps += 1
            light1 = photoDiode1.getValue()
            light2 = photoDiode2.getValue()

    # si light 2> light 1  --> tourne -
    # jusqu-à light1 - light2 > 100
    # tourne + jusqu-à light1 - light 2 < 10
    if light2 > light1
        until light1 - light2 > 100
            motor.backward()
            nbSteps -= 1
            light1 = photoDiode1.getValue()
            light2 = photoDiode2.getValue()

        until light1 - light2 < 10
            motor.forward()
            nbSteps += 1
            light1 = photoDiode1.getValue()
            light2 = photoDiode2.getValue()
 
    # si light2- light 1 < 10 --> pas de nouvelle mesure
    if light2 - light1 < 10
        ; # what??
    
    return nbSteps

    # command  = pid.update(deltaLight).floor()
    
    # console.log "command=" + command

    # motor.move(command)
    
    # goalIsReached = (command.abs() < 5)
    
    # if goalIsReached
    #     console.log "equilibrium found."
    #     return {nbSteps : command, nbMoves : 1}

    # #sleep(200)
    # infos = _searchEquilibrium(motor,photoDiode1,photoDiode2,pid)
    # infos.nbSteps += command
    # infos.nbMoves += 1
    # return infos
        


module.exports = (sensor,device)->

    motor = StepMotor(device,sensor.motor)

    photoDiode1 = Pin.buildAdc(device,sensor.photoDiode1)
    photoDiode2 = Pin.buildAdc(device,sensor.photoDiode2)
 
    # pid = new PidController(1, 0.01, 0.01, 1); # k_p, k_i, k_d, dt 
    # pid.setTarget(sensor.deltaTarget)
    
    return {

        searchEquilibrium : ->
            
            motor.switchOn()
            infos = _searchEquilibrium(motor,photoDiode1,photoDiode2) #,pid)
            motor.switchOff()

            return infos
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