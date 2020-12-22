// IMA NYU Shanghai
// Interaction Lab
// For sending multiple values from Arduino to Processing

int sensors[10];

void setup() {
  Serial.begin(9600);
  for (int i=2; i < 12; i++) {
  pinMode(i, INPUT);  
  }
}

void loop() {
  for (int i=2; i < 12; i++) {
    sensors[i] = digitalRead(i);
    Serial.print(sensors[i]);
    if(i != 11) {
      Serial.print(",");
      }
    
  }

  // keep this format
//  Serial.print(sensor1);
//  Serial.print(",");  // put comma between sensor values
//  Serial.print(sensor2);
//  Serial.print(",");
//  Serial.print(sensor3);
    Serial.println(); // add linefeed after sending the last sensor value

  // too fast communication might cause some latency in Processing
  // this delay resolves the issue.
  delay(100);
}
