int pressed = 0;

void setup() {
  Serial.begin(9600);
  pinMode(D2, INPUT_PULLUP);
}

void loop() {
  if ((digitalRead(D2) == HIGH) && (pressed == 0)) {  // Fixed syntax error
    Serial.println("w");
    pressed = 1;
  }
  else if ((digitalRead(D2) == LOW) && (pressed == 1)) {
    pressed = 0;
  }
  delay(50);
}
