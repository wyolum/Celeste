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
  switch(speed){
  case 0:
    pinMode(M0_PIN, OUTPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, LOW);
    digitalWrite(M0_PIN, LOW);
    break;
  case 1:
    pinMode(M0_PIN, OUTPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, LOW);
    digitalWrite(M0_PIN, HIGH);
    break;
  case 2:
    pinMode(M0_PIN, OUTPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, HIGH);
    digitalWrite(M0_PIN, LOW);
    break;
  case 3:
    pinMode(M0_PIN, OUTPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, HIGH);
    digitalWrite(M0_PIN, HIGH);
    break;
  case 4:
    pinMode(M0_PIN, INPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, LOW);
    digitalWrite(M0_PIN, LOW);
    break;
  case 5:
    pinMode(M0_PIN, INPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, LOW);
    digitalWrite(M0_PIN, HIGH);
    break;
  case 6:
    pinMode(M0_PIN, INPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, HIGH);
    digitalWrite(M0_PIN, LOW);
    break;
  case 7:
    pinMode(M0_PIN, INPUT);
    pinMode(M1_PIN, OUTPUT);
    digitalWrite(M0_PIN, HIGH);
    digitalWrite(M0_PIN, HIGH);
    break;
  }
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
int pw_us = 1000;
void loop(){
  setSpeed(4);
  Serial.println("HERE");
  //  digitalWrite(13, HIGH);
  digitalWrite(nENABLE_PIN, ENABLED);
  for(int i=0; i < 32; i++){
    digitalWrite(STEP_PIN, HIGH);
    delayMicroseconds(pw_us / 2);
    digitalWrite(STEP_PIN, LOW);
    delayMicroseconds(pw_us / 2);
  }
  digitalWrite(nENABLE_PIN, DISABLED);
  delay(60000/200. - 32 * pw_us/1000);
  return;
  Serial.print("    [");
  delay(100);
  for(int i=0; i < 2; i++){
    Serial.print(analogRead(A3));
    Serial.print(", ");
    delay(100);
  }
  Serial.println("],");
  digitalWrite(13, LOW);
  delay(500);
}
