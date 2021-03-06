const int nENABLE_PIN = 8;
const int nSLEEP_PIN = 3;
const int STEP_PIN = 4;


#define ARTHERC
#ifdef ARTHERC
const int DIR_PIN = 9; // for ArtherC
const int M0_PIN = A1;
const int M1_PIN = A2;
#else
const int DIR_PIN = 5; // orig
const int M0_PIN = 6;
const int M1_PIN = 7;
#endif

const int N_STEP = 200;
const bool CW = false;
const bool CCW = !CW;
const bool ENABLED = false;
const bool DISABLED = !ENABLED;
const int SW = A6;

const bool ASLEEP = false;
const bool AWAKE = !ASLEEP;

void setSpeed(int speed){
  pinMode(M0_PIN, (bool)(speed & 1 << 0));
  pinMode(M1_PIN, (bool)(speed & 1 << 1));
  digitalWrite(M0_PIN, (bool)(speed & 1 << 2));
  digitalWrite(M1_PIN, (bool)(speed & 1 << 3));
}

void setup(){
  
  pinMode(SW, INPUT); 
  pinMode(STEP_PIN, OUTPUT);
  pinMode(nENABLE_PIN, OUTPUT);
  pinMode(nSLEEP_PIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(M0_PIN, OUTPUT);
  pinMode(M1_PIN, OUTPUT);

  // digitalWrite(STEP_PIN, HIGH);
  digitalWrite(nSLEEP_PIN, AWAKE);
  digitalWrite(nENABLE_PIN, ENABLED);
  // digitalWrite(nSLEEP_PIN, ASLEEP);
  digitalWrite(M0_PIN, HIGH);
  digitalWrite(M1_PIN, HIGH);
  digitalWrite(SW, HIGH); 

  digitalWrite(DIR_PIN, CW);

  Serial.begin(115200);
  Serial.println("Booted");
  while(1){
     fast(100 * 60, CW);
     delay(100);
     fast(100 * 60, CCW);
     delay(100);
  }
}
bool dir = CW;
bool mode = 0;
int count = 0;
int pw_us = 1000;
const byte SLOW = 8;
const byte FAST = 3;
const byte uSTEPS = 32;

const int    B_NONE= 0;
const int     B_UP = 1;
const int   B_DOWN = 2;
const int B_MIDDLE = 3;
const int   B_LEFT = 4;
const int  B_RIGHT = 5;

void linear_accel(int n_step, bool dir){
  int pw_us = 3000;
  float pw_ms = pw_us / 1000.;
  int min_pw = 1000;
  int ramp_steps = pw_us - min_pw;
  int completed = 0;
  int i;

  setSpeed(FAST);
  digitalWrite(DIR_PIN, dir);
  digitalWrite(nENABLE_PIN, ENABLED);

  float t_ms = pw_us / 1000.;
  float k = 130.;
    
  // ramp up
  while((pw_us > min_pw) && (completed < n_step / 2)){
    pw_us = pw_ms * 1000.;
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(pw_us / 2);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(pw_us / 2);
    pw_ms = 2. * k / (t_ms * t_ms);

    Serial.println(pw_us);
    t_ms += pw_ms;
    completed++;
  }
  ramp_steps = completed;

  // cruse
  for(i=ramp_steps; i < n_step - ramp_steps; i++){
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(pw_us / 2);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(pw_us / 2);
    completed++;
  }
  while((t_ms > 0) && (completed)){
    pw_us = pw_ms * 1000.;
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(pw_us / 2);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(pw_us / 2);
    pw_ms = 2. * k / (t_ms * t_ms);
    t_ms -= pw_ms;
    completed++;
  }

  digitalWrite(nENABLE_PIN, DISABLED);
  setSpeed(SLOW);
  digitalWrite(DIR_PIN, CW);
}

void fast(int n_step, bool dir){
  // execute the number of steps the fastest way possible
  int pw_us = 1500;
  int min_pw = 1000;
  int ramp_steps = pw_us - min_pw;
  int i;

  if(n_step < 2 * ramp_steps){
    ramp_steps = n_step / 2;
  }

  setSpeed(FAST);
  digitalWrite(DIR_PIN, dir);
  digitalWrite(nENABLE_PIN, ENABLED);
  
  // ramp up
  for(i = 0; i < ramp_steps; i++){
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(pw_us / 2);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(pw_us / 2);
    pw_us--;
  }
  
  // cruse
  for(i=ramp_steps; i < n_step - ramp_steps; i++){
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(pw_us / 2);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(pw_us / 2);
  }
  // ramp_down
  for(i = 0; i < ramp_steps; i++){
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(pw_us / 2);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(pw_us / 2);
    pw_us++;
  }

  digitalWrite(nENABLE_PIN, DISABLED);
  setSpeed(SLOW);
  digitalWrite(DIR_PIN, CW);
}

int read_buttons(){
  int reading = analogRead(SW);
  int out;
  if (reading > 900){
    out = B_UP;
  }
  else if (reading > 700){
    out = B_DOWN;
  }
  else if (reading > 500){
    out = B_MIDDLE;
  }
  else if (reading > 300){
    out = B_LEFT;
  }
  else if (reading > 100){
    out = B_RIGHT;
  }
  else{
    out = B_NONE;
  }
  return out;
}

byte speed = SLOW;
void loop(){
  // 4 -- 1 usteps
  // 5 -- 16 usteps
  // 6 -- 1  usteps
  int b_val = read_buttons();
  if(b_val == B_UP){
    fast(200 * 60, CW);
  }
  else if (b_val == B_DOWN){
    fast(200 * 60, CCW);
  }
  else if (b_val == B_RIGHT){
    fast(200, CW);
  }
  else if (b_val == B_LEFT){
    fast(200, CCW);
  }
  setSpeed(speed); // 32 usteps per step?
  digitalWrite(nENABLE_PIN, ENABLED);
  if(speed == SLOW){
    for(int i=0; i < uSTEPS; i++){
      digitalWrite(STEP_PIN, HIGH);
      delayMicroseconds(pw_us / 2);
      digitalWrite(STEP_PIN, LOW);
      delayMicroseconds(pw_us / 2);
    }
    digitalWrite(nENABLE_PIN, DISABLED); 
    int d = 60000/200. - (float)uSTEPS * pw_us / 1000.;
    if(d > 0){
      delay(d);
    }
    Serial.println(d);
  }
  return;
}
