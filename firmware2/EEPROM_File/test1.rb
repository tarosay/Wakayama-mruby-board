# test
	
#Sensor

	sw = 0

	#I2Cピンの設定
	I2c.sdascl( 17, 16 )
	delay(300)
	#Serial.println(0, g.to_s)
	
	#g = I2c.read( DevID, Wai )
	#Serial.println(0, "Who am I = " + g.to_s)

  # Accel Setup [KXSD9-2050]
	Accel = 0x18				# 0b00011000
	#Accel_Write = 0x30			# 0b00110000
  	Accel_CTRL_REGC = 0x0C
	Accel_SENS = 0x02				# 00:+-8G, 01:+-6G, 02:+-4G, 03: +-2G
	Accel_FILLTER = 0xC0		# 00:Non, 20:2000Hz, 80:1000Hz, A0:500Hz, C0:100Hz, E0:50Hz
 
	# +-6G
	I2c.write(Accel, Accel_CTRL_REGC, Accel_SENS | Accel_FILLTER)
	delay(100)

	# Gyro Setup [L3GD20]
	Gyro = 0x6B				# 0b01101011
	#Gyro_Write = 0xD4				# 0b11010110
	Gyro_WHO_AM_I = 0x0F
	Gyro_CTRL_REG1 = 0x20		# Control register
	Gyro_ENABLE = 0x0F
	Gyro_CTRL_REG4 = 0x23		# Control register
	Gyro_CTRL_REG3 = 0x22		# Control register
	Gyro_RANGE = 0x10				# 00:+-250dps, 10:+-500dps, 30:+-2000dps
	Gyro_dps = 0.0175				# 00:0.00875, 10:0.0175, 30:0.07

	val = I2c.read( Gyro, Gyro_WHO_AM_I)
	Serial.println(0, "Gyro Who am I? = " + val.to_s)

	# Turn on all axes, disable power down
	I2c.write(Gyro, Gyro_CTRL_REG1, Gyro_ENABLE)
	delay(100)
	# +-500dps
	I2c.write(Gyro, Gyro_CTRL_REG4, Gyro_RANGE)
	delay(100)

	while(true) do
		
		v0 = I2c.read( Accel, 1, 0)
		v2 = I2c.read( Accel, 3, 2)
		v4 = I2c.read( Accel, 5, 4)
		x = (v0 / 16).truncate
		y = (v2 / 16).truncate
		z = (v4 / 16).truncate
		Serial.print(0, " Ax=" + x.to_s + " Ay=" + y.to_s + " Az=" + z.to_s)
		Serial.print(2, x.to_s + "," + y.to_s + "," + z.to_s)
		
		#Address 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D
		v0 = I2c.read( Gyro, 0x28, 0x29)
		v1 = I2c.read( Gyro, 0x2A, 0x2B)
		v2 = I2c.read( Gyro, 0x2C, 0x2D)

		if v0 > 32767
			v0 = v0 - 65536
		end

		if v1 > 32767
			v1 = v1 - 65536
		end

		if v2 > 32767
			v2 = v2 - 65536
		end
		v0 = v0 * Gyro_dps
		v1 = v1 * Gyro_dps
		v2 = v2 * Gyro_dps
		Serial.println(0, " Gx=" + v0.to_s + " Gy=" + v1.to_s + " Gz=" + v2.to_s)
		Serial.println(2, "," + v0.to_s + "," + v1.to_s + "," + v2.to_s)

		if(Serial.available(0)>0)then
			Sys.fileload()
		end
  
		led(sw)
		sw = 1 - sw
		
		delay(500)
		
	end
