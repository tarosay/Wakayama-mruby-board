# coding: utf-8
# シリアル通信

@Mem = MemFile
@Srv = Servo
@S = Serial
@Sy = System

	@S.begin(0, 9600)		#USBシリアル通信の初期化
	@S.begin(1, 9600)
	c = "A"
	while(true) do
		delay(10)

		if(@S.available(0)>0)then
			#Serial.write(1, Serial.read(0).chr, 1)
			c = @S.read(0).chr
			@S.print(1, c)
			#Serial.print(0, c)
		end

		if(@S.available(1)>0)then
			#Serial.write(0, Serial.read(1).chr, 1)
			c = @S.read(1).chr
			@S.print(0, c)
		end
	end
