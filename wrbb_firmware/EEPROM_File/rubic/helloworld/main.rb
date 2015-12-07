#!mruby
Serial.begin(0, 115200)
k = 1
300.times do |n|
    led k
    k = 1 - k
    Serial.println(0, "#{n.to_s}:Hello World!")
    delay 100
end
led 0
