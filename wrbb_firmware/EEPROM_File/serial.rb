#################################
# シリアル通信
#################################

	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	Serial.begin(1, 115200)		#USBシリアル通信の初期化
	c = "A"
	while(true) do
		delay(10)

		if(Serial.available(0)>0)then
			#Serial.write(1, Serial.read(0).chr, 1)
			c = Serial.read(0).chr
			Serial.print(1, c)
			#Serial.print(0, c)
		end

		if(Serial.available(1)>0)then
			#Serial.write(0, Serial.read(1).chr, 1)
			c = Serial.read(1).chr
			Serial.print(0, c)
		end
	end
