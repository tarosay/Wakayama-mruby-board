#!mruby
Serial.begin(0, 115200)
Serial.println(0, "LED Fuwa")

pwm(25,0)

for i in 0..24 do
    pinMode(i, 0)
end

x = 0
s = 10
for i in 0..100 do
    Serial.println(0, x.to_s)
    pwm(25,x)
    x = x + s
    if(x <= 0)then
        s = 10
    elsif(x >= 250)then
        s = -10
    end
    delay 100
end
    
pwm(25,0)

Serial.println(0, "Stop!")
