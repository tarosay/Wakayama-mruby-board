#!mruby
Serial.begin(0, 115200)
Serial.println(0, "Light Sensor2")

pinMode(9, 0)

while true
  if(digitalRead(9) == 1)then
    break
  end
  
  d = analogRead(14)
  Serial.println(0, d.to_s)
  delay 100
end
