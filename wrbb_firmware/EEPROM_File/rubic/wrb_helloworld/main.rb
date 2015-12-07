#!mruby
@M = MemFile

@M.copy("main.mrb", "hello.mrb")

Serial.begin(0, 115200)
k = 1
8.times do |n|
    led k
    k = 1-k
    Serial.println(0, "#{n.to_s}:Hello WRB!")
    delay 300
end
led 0
