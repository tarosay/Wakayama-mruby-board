#!mruby
pos = 0
inc = 10
Serial.begin(0, 115200)
Servo.attach(0, 8)
Servo.write(0, pos)

50.times do
    delay 100
    pos += inc
    Servo.write(0, pos)
    inc *= -1 if pos >= 180 or pos <= 0
end
