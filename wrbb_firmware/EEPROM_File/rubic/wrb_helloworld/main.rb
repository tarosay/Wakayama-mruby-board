#!mruby
Serial.begin(0, 115200)
10.times do |n|
    Serial.println(0, "#{n.to_s}:Hello world!")
    delay 500
end

#System.setrun("main.mrb")
