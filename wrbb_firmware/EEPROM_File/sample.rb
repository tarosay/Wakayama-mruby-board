# Ruby Board



	Serial.begin(0, 115200)		#USBシリアル通信の初期化

	#g = "\0\1\2\3\4\5\6\7\8\9"
	g = 10.chr + 11.chr + 12.chr + 13.chr + 14.chr + 15.chr + 16.chr + 17.chr + 18.chr + 19.chr
	f = 0.chr + 1.chr + 2.chr + 3.chr + 4.chr

	Mem.open(0, 'sample.txt', 2)
		Mem.write(0, 'Hello mruby World', 17)
		data = 0x30.chr + 0x31.chr + 0.chr + 0x32.chr + 0x33.chr
		Mem.write(0, data, 5 )
		Mem.write(0, g, 10 )
		Mem.write(0, f, 3 )
	Mem.close(0)

	Mem.open(0, 'sample.txt', 0)

	Serial.println(0, "Reading")
	
	while(true)do
		c = Mem.read(0)
		#Serial.write(0, c.chr, 1)
		#Serial.println(0, c.chr)
		if(c < 0)then
			break
		end
		Serial.write(0, c.chr, 1)
	end
	
	Serial.println(0, "Close")
	Mem.close(0)
	Sys.exit()
	