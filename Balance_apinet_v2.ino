#include <LiquidCrystal.h>
#include <TimerOne.h>
#include <EEPROM.h>
#include <Akeru.h>
#include <SoftwareSerial.h>



#define PWMA 3
#define DIRA 12
#define PWMB 11
#define DIRB 13

#define LED 13


//Akeru
typedef struct  {
  int optDiff;
  unsigned long motorPosition;
  float weight;
  int increment;
} packetT;

packetT packet;

unsigned long lastSend;



// initialize the library with the numbers of the interface pins
LiquidCrystal lcd(8, 10, A2, A3, A4, A5);

// gestion du menu et du switch
int switchState, switchPushDuration;
unsigned long switchLastFall, switchDebounce;
bool menuAction = 0;
int menuCounter;
char buff[8];

//timer
long period;

//optical sensor
int v0, v1, optDiff, diffMin, diffMinBuf, diffMax, diffMaxBuf, diffPrev, diffSens, diffLowPass, diffCC;
long diffLastMin, diffLastMax;


//stepper motor
int motorDirection, prevMotorDirection;
unsigned long motorPosition, motorLastPos;
#define periodFast 15000
#define periodSlow 100000
#define periodSuperSlow 1000000


//pesee
#define stepToGram 0.64
bool peseeTerminee = false;


#define switchPin 2


void setup() {
  Serial.begin(9600);


//  pinMode(LED,OUTPUT);
  delay(5000);
  Akeru.begin();
  Akeru.setPower(5);
  packet.increment = (EEPROM.read(0) << 8) + EEPROM.read(1);

  
  
  //lcd enable pin
  pinMode(9,OUTPUT);
  digitalWrite(9,LOW); 

  // motor  
  pinMode(PWMA,OUTPUT);
  pinMode(PWMB,OUTPUT);  
  pinMode(DIRA,OUTPUT);
  pinMode(DIRB,OUTPUT);  
  
  //optical sensor
  pinMode(A0,INPUT);    
  pinMode(A1,INPUT);  
  
  ReadPositionEEPROM();
  
  lcd.begin(20, 4);
  lcd.noBlink();
  menuInit();


  pinMode(switchPin, INPUT);
  digitalWrite(switchPin, HIGH);   
  attachInterrupt(0, switchChange, CHANGE);
  
  period = periodFast;
  Timer1.initialize(period); // set a timer of length 100000 microseconds (or 0.1 sec - or 10Hz => the led will blink 5 times, 5 cycles of on-and-off, per second)
  Timer1.attachInterrupt( timerIsr );   
}

void loop() {
  delay(50);
  opticalLoop();
  menuLoop();

  if ((millis() - lastSend) > 600000) { // 10 minutes  
    rechercheEquilibre();
  }
}

void switchChange() { 
  unsigned long m = millis();
  
  if ((m - switchDebounce) > 30) {
    if (switchLastFall && (digitalRead(switchPin) == HIGH)) {
      switchPushDuration = m - switchLastFall;
      if (switchPushDuration > 500) menuCounter++;
      else menuAction = 1;
      switchLastFall = 0;
    } 
    else 
      switchLastFall = m;
  } 
  switchDebounce = m;
}

void timerIsr()
{
  byte stepidx, pwmpin, dir;
  motorPosition += motorDirection;
  
  stepidx = motorPosition % 4;
  dir = (stepidx & 2) >> 1;
  pwmpin = (stepidx & 1) ? PWMA : PWMB;
  
  
  digitalWrite(PWMA,LOW);
  digitalWrite(PWMB,LOW);
  digitalWrite(DIRA,LOW);
  digitalWrite(DIRB,LOW);
    
  if (motorLastPos != motorPosition) {
    digitalWrite(DIRA,dir);
    digitalWrite(DIRB,dir);
    digitalWrite(pwmpin,HIGH);
  }
  motorLastPos = motorPosition;
}


void menuInit() {
  lcd.setCursor(0,0);
  lcd.print("Balance v2");
  
  lcd.setCursor(15,0);
  lcd.print("pesee");
  lcd.setCursor(15,1);
  lcd.print("++   ");
  lcd.setCursor(15,2);
  lcd.print("--   ");
  lcd.setCursor(15,3);
  lcd.print("tare ");
}

void menuLoop() {
  if (menuAction == 1) {
    menuAction = 0;
    
    switch (menuCounter%4) {
    case 0:
      rechercheEquilibre(); break;      
    case 1:
      motorPosition++; break;
    case 2:
      motorPosition--; break;      
    case 3:
      motorPosition = 0; break;            
    }
  } 
  

  lcd.setCursor(14, (menuCounter-1) % 4);
  lcd.print(" ");
  lcd.setCursor(14, menuCounter%4);
  lcd.print(">");

  
/*  snprintf(buff,8, "%4d", switchPushDuration);
  lcd.setCursor(10, 1);  
  lcd.print(buff);

  snprintf(buff,8, "%4d", menuCounter);
  lcd.setCursor(10, 2);  
  lcd.print(buff);*/


/*  snprintf(buff,8, "%4d", optDiff);
  lcd.setCursor(6, 1);  
  lcd.print(buff);*/
/*  snprintf(buff,8, "%2d", motorDirection);
  lcd.setCursor(0, 1);  
  lcd.print(buff);  */

  snprintf(buff,8, "%4d", motorPosition);
  lcd.setCursor(0, 2);  
  lcd.print(buff);  
  

}

void opticalLoop() {
  
  v0 = analogRead(A0);
  v1 = analogRead(A1);

  optDiff = v1 - v0;


  if (diffSens == 1) {
    if (optDiff < diffPrev) diffLowPass ++;
    else diffLowPass = 0;
    
    if (optDiff > diffMaxBuf) diffMaxBuf = optDiff;
    
    if (diffLowPass > 2) {
      diffMinBuf = optDiff;
      diffMax = diffMaxBuf;
      diffSens = -1;
      diffLastMax = millis();
    }

  } else {
    if (optDiff > diffPrev) diffLowPass ++;
    else diffLowPass = 0;  
   
    if (optDiff < diffMinBuf) diffMinBuf = optDiff;
    
    if (diffLowPass > 2) {
      diffMaxBuf = optDiff;
      diffMin = diffMinBuf;
      diffSens = 1;      
      diffLastMin = millis();      
    } 
  }
  diffPrev = optDiff;


  if (((millis() - diffLastMin) > 4000) || ((millis() - diffLastMax) > 4000))
    diffCC = optDiff;
  else   
    diffCC = (diffMax + diffMin) / 2;
    
/*
  Serial.print(optDiff);
  Serial.print("\t");
  Serial.print(diffMin);
  Serial.print("\t");
  Serial.print(diffMax);
  Serial.print("\t");
  Serial.println(diffCC);
*/
    
  snprintf(buff,8, "%4d", optDiff);
  lcd.setCursor(6, 1);  
  lcd.print(buff);

  snprintf(buff,8, "%4d", diffCC);
  lcd.setCursor(6, 2);  
  lcd.print(buff);  
}  
  

long rechercheEquilibre() {
  bool continueLoop = true;
  unsigned long lastMotorAction = millis();
  prevMotorDirection = 3;

  lcd.setCursor(0,3);
  lcd.print("rech equ fast");
  
  period = periodFast;
  Timer1.initialize(period);

  while (continueLoop) {

    opticalLoop();

    if ((abs(optDiff) > 800) || (abs(diffCC) > 20)) {
      if (abs(optDiff) > 800) {
        Timer1.initialize(periodFast);
        motorDirection = optDiff < 0 ? -1 : 1;
      } else {
        motorDirection = diffCC < 0 ? -1 : 1;
        if (abs(diffCC) > 300) Timer1.initialize(periodSlow);      
        else Timer1.initialize(periodSuperSlow);               
      }

      lastMotorAction = millis();
    } else {
     motorDirection = 0; 
     if ((millis() - lastMotorAction) > 4000) {
       continueLoop = false;
     }
    }
  }

  peseeTerminee = true;
  lcd.setCursor(0,3);  
  lcd.print("termine  ");

/*  Serial.println("terminé...");
  Serial.println(motorPosition);  */
  AkeruSendWeight();

  
  StorePositionEEPROM();
  
  return motorPosition;
}


void AkeruSendWeight() {
    packet.increment++;
    EEPROM.write(0,(packet.increment>>8) & 255);
    EEPROM.write(1,(packet.increment) & 255);
    
    packet.weight = motorPosition * 5.0 / 3100.0;
    
    packet.motorPosition = motorPosition;
    packet.optDiff = optDiff;
    
/*    Serial.println("sending....");
    Serial.println(packet.increment);    
    Serial.println(packet.analogValueAvg);        
    Serial.println(Akeru.send(&packet, sizeof(packet)));*/
    Akeru.send(&packet, sizeof(packet));
    
    lastSend = millis();
}


/*void pesee() {
  long valBrute = rechercheEquilibre();
  poidsKg = round(valBrute / 13.50) / 100.0;

  
  dtostrf(poidsKg,3,2,buf);  
  return;
}*/


void StorePositionEEPROM() {
  for (int i = 0; i < 4; i++) {
    EEPROM.write(i+2,((byte*)&motorPosition)[i]);
  }
}

void ReadPositionEEPROM() {
  for (int i = 0; i < 4; i++) {
    ((byte*)&motorPosition)[i] = EEPROM.read(i+2);
  }
}

