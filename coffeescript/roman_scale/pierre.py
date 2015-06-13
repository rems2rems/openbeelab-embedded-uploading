
#!/usr/bin/python
# -*- coding: latin-1 -*-

#from ablib import Pin 
import time

class Pin:

	def __init__(self,no,mode):
		pass
	
	def on(self):
		pass
		#print("on")

	def off(self):
		pass
		#print("off")

	def digitalRead(self):
		if positionContrepoids < 10 :
			return 1
		else:
			return 0

pin1 = Pin('J4.37','OUTPUT') #mettre les numeros de pin en fonction de la carte
pin2 = Pin('J4.35','OUTPUT')
pin3 = Pin('J4.33','OUTPUT')
pin4 = Pin('J4.31','OUTPUT')
pinContactBas = Pin('J4.32','INPUT') #capteur bras de balance en bas

positionContrepoids = 0

SEQA = [(pin1,),(pin1,pin2),(pin2,),(pin2,pin3),(pin3,),(pin3,pin4),(pin4,),(pin4,pin1)]
RSEQA = [(pin4,),(pin4,pin3),(pin3,),(pin3,pin2),(pin2,),(pin2,pin1),(pin1,),(pin1,pin4)]

PINS = [pin1,pin2,pin3,pin4]

DELAY = 0.002

def readPositionContrepoids ():
        with open('position_contrepoids.txt') as f:
     		return int(f.readline())  # read first line

def savePositionContrepoids(positionContrepoids):
	with open('position_contrepoids.txt') as f:
		f.write('%d' % positionContrepoids)

def stepper(sequence, pins):
    for step in sequence:
        for pin in pins:
            pin.on() if pin in step else pin.off()
        time.sleep(DELAY)      

def brasHaut():
	return not(brasBas())

def brasBas():
	return pinContactBas.digitalRead() == 1

def marcheAvant():
	global positionContrepoids
	stepper(SEQA,PINS)  # forward
	positionContrepoids = positionContrepoids  + 1
	print("avant " + str(positionContrepoids))

def marcheArriere():
	global positionContrepoids
	stepper(RSEQA,PINS)
	positionContrepoids = positionContrepoids  - 1
	print("arriere " + str(positionContrepoids))

def petiteMarcheArriere():
	for _ in xrange(120): #valeur a ajuster
		marcheArriere()

try:

	positionContrepoids = readPositionContrepoids()
	print(positionContrepoids)

	#la ruche a perdu du poids, il faut reculer
	while brasHaut():
		marcheArriere()


	#cas nominal, on fait systematiquement une petite marche arriere, puis une lecture de poids normale
	petiteMarcheArriere()

	while brasBas():
		marcheAvant()

	savePositionContrepoids(positionContrepoids)

finally:
    #GPIO.cleanup()
	pass




