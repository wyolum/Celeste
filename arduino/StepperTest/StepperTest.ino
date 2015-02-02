const int nENABLE_PIN = 2;
const int nSLEEP_PIN = 3;
const int STEP_PIN = 4;
const int DIR_PIN = 5;
const int M0_PIN = 6;
const int M1_PIN = 7;
const int N_STEP = 200;
const bool CW = false;
const bool CCW = !CW;
const bool ENABLED = false;
const bool DISABLED = !ENABLED;

const bool ASLEEP = false;
const bool AWAKE = !ASLEEP;

void setSpeed(int speed){
  pinMode(M0_PIN, (bool)(speed & 1 << 0));
  pinMode(M1_PIN, (bool)(speed & 1 << 1));
  digitalWrite(M0_PIN, (bool)(speed & 1 << 2));
  digitalWrite(M1_PIN, (bool)(speed & 1 << 3));
}

void setup(){

  pinMode(STEP_PIN, OUTPUT);
  pinMode(nENABLE_PIN, OUTPUT);
  pinMode(nSLEEP_PIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(M0_PIN, OUTPUT);
  pinMode(M1_PIN, OUTPUT);

  // digitalWrite(STEP_PIN, HIGH);
  // digitalWrite(nSLEEP_PIN, AWAKE);
  digitalWrite(nENABLE_PIN, ENABLED);
  // digitalWrite(nSLEEP_PIN, ASLEEP);
  digitalWrite(M0_PIN, HIGH);
  digitalWrite(M1_PIN, HIGH);

  digitalWrite(DIR_PIN, CW);

  Serial.begin(115200);
  Serial.println("Booted");
  digitalWrite(nENABLE_PIN, ENABLED);
}
bool dir = CW;
bool mode = 0;
int count = 0;
int pw_ms = 2;
const byte SLOW = 8;
const byte FAST = 3;
const byte uSTEPS = 32;

void loop(){
  // 4 -- 1 usteps
  // 5 -- 16 usteps
  // 6 -- 1  usteps
  byte speed = SLOW;
  setSpeed(speed); // 32 usteps per step?
  Serial.println(count);
  digitalWrite(nENABLE_PIN, ENABLED);
  if(speed == SLOW){
    for(int i=0; i < uSTEPS; i++){
      digitalWrite(STEP_PIN, HIGH);
      delay(pw_ms / 2);
      digitalWrite(STEP_PIN, LOW);
      delay(pw_ms / 2);
    }
    digitalWrite(nENABLE_PIN, DISABLED); 
    delay(60000/200. - 32 * pw_ms);
  }
  else{
    for(int i=0; i < 200; i++){
      digitalWrite(STEP_PIN, HIGH);
      delay(pw_ms / 2);
      digitalWrite(STEP_PIN, LOW);
      delay(pw_ms / 2);
    }
    digitalWrite(nENABLE_PIN, DISABLED); 
  }
  return;
}
