#include <Wire.h>
#include "AFMotor.h"
#include "rtcBOB.h"
#include "Time.h"
#include "rtcBOB.h"

// Connect a stepper motor with 48 steps per revolution (7.5 degree)
// to motor port #2 (M3 and M4)
const int STEPS_PER_REV = 48;
AF_Stepper motor(STEPS_PER_REV, 2);
const int DT = 75;

uint32_t next_step_time;

time_t _last_tick = 0;
void setup() {
  Serial.begin(115200);
  Serial.println("Gear Clock");
  Serial.println("WyoLum 2014");
  Serial.println("Buy Open Hardware and own your future!");
  
  Wire.begin();
  motor.setSpeed(40);  // 10 rpm   
  
  uint32_t now = getTime();
  next_step_time = now + DT - now % DT;
  pinMode(13, OUTPUT);
  //digitalWrite(13, HIGH);
  // delay(100);
  digitalWrite(13, LOW);
  motor.step(1, FORWARD, SINGLE); // 48 steps
  delay(100);
  motor.step(1, BACKWARD, SINGLE); // 48 steps
  delay(100);
  _last_tick = getTime();
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
  time_t tick = _last_tick +  3600 / STEPS_PER_REV;
  motor.release();
  while(getTime() < tick){
    delay(10);
    //Serial.print(tick - getTime());
    //Serial.println(" togo");
  }
  _last_tick = tick;
  motor.step(1, FORWARD, SINGLE); // 48 steps
  // motor.onestep(FORWARD, INTERLEAVE);
  // delay(74000);
}
