#include <Wire.h>
#include "AFMotor.h"
#include "rtcBOB.h"
#include "Time.h"
#include "rtcBOB.h"

// Connect a stepper motor with 48 steps per revolution (7.5 degree)
// to motor port #2 (M3 and M4)
AF_Stepper motor(48, 2);
const int DT = 75;

uint32_t next_step_time;

void setup() {
  Serial.begin(115200);
  Serial.println("Gear Clock");
  Serial.println("WyoLum 2014");
  Serial.println("Buy Open Hardware and own your future!");
  
  Wire.begin();
  motor.setSpeed(10);  // 10 rpm   
  
  uint32_t now = getTime();
  next_step_time = now + DT - now % DT;
  pinMode(13, OUTPUT);
  //digitalWrite(13, HIGH);
  // delay(100);
  digitalWrite(13, LOW);
  delay(100);
  motor.step(1, FORWARD, MICROSTEP); // 48 steps
}

void loop(){
  /*while(getTime() < next_step_time){
    delay((next_step_time - getTime()) * 1000);
  }
  next_step_time += DT;
  Serial.println(getTime());
  motor.step(2 * 1, FORWARD, INTERLEAVE); 
  */
  //motor.step(48, FORWARD, SINGLE); // 48 steps
  //motor.step(48, FORWARD, DOUBLE); // 48 steps
  // motor.step(48, FORWARD, INTERLEAVE); // 48 steps
  time_t now = getTime();
  time_t tick = now;// + 3600/48;
  motor.release();
  while(getTime() < tick){
    delay(100);
  }
  motor.step(1, FORWARD, MICROSTEP); // 48 steps
  // motor.onestep(FORWARD, INTERLEAVE);
  // delay(74000);
}
