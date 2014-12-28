#include <Wire.h>
#include "AFMotor.h"
#include "rtcBOB.h"
#include "Time.h"
#include "rtcBOB.h"

// Connect a stepper motor with 48 steps per revolution (7.5 degree)
// to motor port #2 (M3 and M4)
const int STEPS_PER_REV = 48;
AF_Stepper motor(STEPS_PER_REV, 2);
// const int DT = 3600/STEPS_PER_REV;
const int DT = 1;

time_t _next_tick = 0;
void setup() {
  uint8_t ahh, amm, ass, spm, is_set;
  time_t t;

  Serial.begin(115200);
  Serial.println("Gear Clock");
  Serial.println("WyoLum 2014");
  Serial.println("Buy Open Hardware and own your future!");
  
  Wire.begin();

  /// total reset
  t = getTime();
  ahh = (t / 3600);
  amm = (t  - ahh * 3600) / 60;
  ahh = t % 60 ;
  setRTC_alarm(ahh, amm, ass, 0);

  motor.setSpeed(40);  // 10 rpm   
  
  uint32_t now = getTime();
  pinMode(13, OUTPUT);
  //digitalWrite(13, HIGH);
  // delay(100);
  digitalWrite(13, LOW);
  motor.step(1, FORWARD, SINGLE); // 48 steps
  delay(100);
  motor.step(1, BACKWARD, SINGLE); // 48 steps
  delay(100);

  // alarm time on RTC is the next tick time.
  getRTC_alarm(&ahh, &amm, &ass, &is_set);
  _next_tick = ahh * 3600 + amm * 60 + ass + DT;
  
  int togo = int(_next_tick) - (int)(getTime() % 86400);
  Serial.println(togo / DT);
  if(togo > 0){
    motor.step(togo / DT, FORWARD, SINGLE);
  }
}

void loop(){
  time_t togo, t;
  uint8_t hh, mm, ss;
  motor.release();

  t = getTime() % 86400;
  _next_tick = t + 10;

  togo = t + _next_tick;
  Serial.println(togo);
  while(togo > 0){
    t = getTime() % 86400;
    togo = _next_tick - t;
    delay(1000);
    Serial.print("    ");
    Serial.print(_next_tick);
    Serial.print(" ");
    Serial.println(togo);
  }
  _next_tick += DT;
  uint8_t ahh, amm, ass, aset;
  ahh = (_next_tick / 3600) % 12;
  amm = (_next_tick - 3600 * ahh) / 60;
  ass = _next_tick % 60;
  setRTC_alarm(ahh, amm, ass, 0);
  motor.step(1, FORWARD, SINGLE);
}
