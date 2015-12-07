#!mruby
Serial.begin(0, 115200)
Serial.println(0, "Switch")

pwmHz 440
pwm(6,0)
pinMode(9, 0)

100.times do
    b = digitalRead(9)
    if(b == 1)then
       pwm(6,128)
    else
       pwm(6,0)
    end
    led b
    Serial.println(0, b.to_s)
    delay 100
end
pwm(6,0)
