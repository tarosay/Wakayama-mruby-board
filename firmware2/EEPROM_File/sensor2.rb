#Sensor

	Wai = 0x75		# Who am I?
	Pw = 0x6B
	Pincfg = 0x37
	Accfg = 0x1C
	Gycfg = 0x1B
	DevID = 0x68

	AxL = 0x3C
	AxH = 0x3B
	AyL = 0x3E
	AyH = 0x3D
	AzL = 0x40
	AzH = 0x3F
	TmL = 0x42
	TmH = 0x41
	GxL = 0x44
	GxH = 0x43
	GyL = 0x46
	GyH = 0x45
	GzL = 0x48
	GzH = 0x47
	sw = 0

	#Serial.println(0, " 1.")

	#I2Cピンの設定
	I2c.sdascl( 17, 16 )
	delay(300)
	#Serial.println(0, g.to_s)
	
	#g = I2c.read( DevID, Wai )
	#Serial.println(0, "Who am I = " + g.to_s)
	
	#Clear the 'sleep' bit to start the sensor.
	I2c.write(DevID, Pw, 0)
	I2c.write(DevID, Pincfg, 2)
	
	#加速度センサの設定 +-4g(-4096_4095), LPF=5Hz
	cfg = I2c.read(DevID, Accfg) | 0x10 | 0x01
	I2c.write(DevID, Accfg, cfg)
	#cfg = I2c.read(DevID, Accfg)

	#ジャイロの設定 +-500deg/s
	cfg = I2c.read(DevID, Gycfg) | 0x08
	I2c.write(DevID, Gycfg, cfg)
	#cfg = I2c.read(DevID, Gycfg)

	100.times do
		#加速度
		xa = I2c.read(DevID, AxL, AxH)
		ya = I2c.read(DevID, AyL, AyH)
		za = I2c.read(DevID, AzL, AzH)
		
		if xa > 32767
			xa = xa - 65536
		end
	
		if ya > 32767
			ya = ya - 65536
		end
		
		if za > 32767
			za = za - 65536
		end
		
		#温度
		templ = I2c.read(DevID, TmL, TmH)
		
		if templ > 32767
			templ = templ - 65536
		end
		templ = templ / 340.0 + 35.0

		#Gyro
		xgy = I2c.read(DevID, GxL, GxH)
		ygy = I2c.read(DevID, GyL, GyH)
		zgy = I2c.read(DevID, GzL, GzH)

		if xgy > 32767
			xgy = xgy - 65536
		end
		
		if ygy > 32767
			ygy = ygy - 65536
		end
		
		if zgy > 32767
			zgy = zgy - 65536
		end
		
		Serial.print(0, "T:" + templ.to_s)

		Serial.print(0, " ACX:" + xa.to_s)
		Serial.print(0, " ACY:" + ya.to_s)
		Serial.print(0, " ACZ:" + za.to_s)
		
		Serial.print(0, " GRX:" + xgy.to_s)
		Serial.print(0, " GRY:" + ygy.to_s)
		Serial.println(0, " GRZ:" + zgy.to_s)
		
		delay(100)
		
		led(sw)
		sw = 1 - sw
	end	

