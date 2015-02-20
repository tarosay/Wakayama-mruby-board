# test
	
i = 0
50.times do
		Serial.print(2, i.to_s)
		i = i + 1
		delay(250)
		led(i % 2)
end



