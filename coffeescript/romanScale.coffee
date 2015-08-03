
searchEquilibrium = (motor,photoDiodeTop,photoDiodeBottom) ->

    totalSteps = 0

    ligth = photoDiodeTop.analogRead()
    while ligth < 400 or ligth > 600

        command = 100 #steps
        if ligth < 400
            motor.forward(command)
            totalSteps += command
        else
            motor.backward(command)
            totalSteps -= command

        ligth = photoDiodeTop.analogRead()
        


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