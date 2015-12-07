#!mruby
Serial.begin(0, 115200)
Serial.println(0, "Switch")

pinMode(9, 0)

100.times do
    b = digitalRead(9)
    led b
    Serial.println(0, b.to_s)
    delay 100
end
