#!mruby
Serial.begin(0, 115200)
Serial.println(0, "Light Sensor and Buzzer")
lmax = 400
lmin = 170
hz = 0
pwm(6,128)
pwmHz hz
pinMode(9, 0)
while true
  if(digitalRead(9) == 1)then
    break
  end
  d = analogRead(14)
  Serial.println(0, d.to_s)
  
  hz = (d - lmin)/(lmax-lmin)*(6000-20) + 20
  pwmHz hz
  delay 120
end
pwm(6,0)
