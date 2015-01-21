const int STEP_PIN = 2;
const int DIR_PIN = 3;
const int M0_PIN = 4;
const int M1_PIN = 5;
const int N_STEP = 200;

void setup(){
  pinMode(4, OUTPUT);
  pinMode(7, OUTPUT);
  digitalWrite(4, HIGH);
  digitalWrite(7, HIGH);
  pinMode(STEP_PIN, OUTPUT);
  pinMode(DIR_PIN, OUTPUT);
  pinMode(M0_PIN, OUTPUT);
  pinMode(M1_PIN, OUTPUT);
  digitalWrite(STEP_PIN, LOW);
  digitalWrite(DIR_PIN, LOW);
  digitalWrite(M0_PIN, LOW);
  digitalWrite(M1_PIN, LOW);
  Serial.begin(115200);
  digitalWrite(M0_PIN, LOW);
  digitalWrite(M1_PIN, LOW);
}
bool dir = true;
bool mode = 0;
void loop(){
  digitalWrite(DIR_PIN, dir);
  for(int i=0; i < N_STEP; i++){
    digitalWrite(STEP_PIN, HIGH);
    delay(1);
    digitalWrite(STEP_PIN, LOW);
    delay(1);
  }
  Serial.print("    [");
  delay(100);
  for(int i=0; i < 2; i++){
    Serial.print(analogRead(A3));
    Serial.print(", ");
    delay(100);
  }
  Serial.println("],");
  delay(400);
}
