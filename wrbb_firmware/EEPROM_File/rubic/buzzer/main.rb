#!mruby
Serial.begin(0, 115200)
Serial.println(0, "Buzzer")

pwm(6,128)
pwmHz 440
delay 1000

pwmHz 6000
delay 1000

pwm(6,0)
