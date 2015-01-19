const int STEP_PIN = 2;
const int N_STEP = 200;

void setup(){
  pinMode(4, OUTPUT);
  pinMode(7, OUTPUT);
  digitalWrite(4, HIGH);
  digitalWrite(7, HIGH);
  pinMode(STEP_PIN, OUTPUT);
  digitalWrite(STEP_PIN, LOW);
}
void loop(){
  for(int i=0; i < N_STEP; i++){
    for(int j=0; j < 1; j++){
      digitalWrite(STEP_PIN, HIGH);
      delay(1);
      digitalWrite(STEP_PIN, LOW);
      delay(1);
    }
  }
  delay(800);
}
