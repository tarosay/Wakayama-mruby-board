#!mruby
Serial.begin(0, 115200)
Serial.println(0, "Light Sensor")

70.times do|i|
  d = analogRead(14)
  Serial.println(0, i.to_s + ': '+ d.to_s)
  delay 250
end
