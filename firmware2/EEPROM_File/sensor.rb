#Sensor

	sw = 0

	#Serial.println(0, " 1.")

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

	APTemp = 0x5D						# 0b01011101
	#APTemp_Write    0xBA    //0b10111010
	APTemp_WHO_AM_I = 0x0F
	APTemp_CTRL_REG1 = 0x20	# Control register
	APTemp_SAMPLING = 0xA0	# A0:7Hz, 90:1Hz

	val = I2c.read( APTemp, APTemp_WHO_AM_I )
	Serial.println(0, "APTemp Who am I? = " + val.to_s)

	# 7Hz
	I2c.write(APTemp, APTemp_CTRL_REG1, APTemp_SAMPLING)
	delay(100);

	100.times do
		
		v0 = I2c.read( Accel, 1, 0)
		#v1 = I2c.read( Accel, 1)
		v2 = I2c.read( Accel, 3, 2)
		#v3 = I2c.read( Accel, 3)
		v4 = I2c.read( Accel, 5, 4)
		#v5 = I2c.read( Accel, 5)
		#x =   v0 * 16 + (v1 / 16).truncate
		#y =   v2 * 16 + (v3 / 16).truncate
		#z =   v4 * 16 + (v4 / 16).truncate
		x = (v0 / 16).truncate
		y = (v2 / 16).truncate
		z = (v4 / 16).truncate
		#Serial.print(0, " Ax=" + x.to_s + " Ay=" + y.to_s + " Az=" + z.to_s)
		
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
		#Serial.print(0, " Gx=" + v0.to_s + " Gy=" + v1.to_s + " Gz=" + v2.to_s)
		
		#Address 0x28, 0x29, 0x2A, 0x2B, 0x2C
		v0 = I2c.read( APTemp, 0x28, 0x29)
		v1 = I2c.read( APTemp, 0x2A)
		v2 = I2c.read( APTemp, 0x2B, 0x2C)

		a = v0 + v1 * 65536
		a = a / 4096.0		# hPa単位に直す

		if v2 > 32767
			v2 = v2 - 65536
		end
		t = v2 / 480.0 + 42.5
		Serial.println(0, " Pr=" + a.to_s + " Te=" + t.to_s)
		delay(250)

		#val = I2c.read( Gyro, Gyro_WHO_AM_I)
		#Serial.println(0, "Gyro Who am I? = " + val.to_s)
		#delay(500);

		#val = I2c.read( APTemp, APTemp_WHO_AM_I )
		#Serial.println(0, "APTemp Who am I? = " + val.to_s)
		#delay(500);
		
		
		led(sw)
		sw = 1 - sw
	end

#    //Turn on all axes, disable power down
#    tx[0] = Gyro_CTRL_REG1;
#    tx[1] = Gyro_ENABLE;
#    i2c.write( write, tx, 2);
#    wait(0.1);

##    //tx[0] = Gyro_CTRL_REG3;
 #   //tx[1] = 0x00;
 #   //i2c.write( write, tx, 2);
 #   //wait(0.1);
    
#    //+-500dps
#    tx[0] = Gyro_CTRL_REG4;
#    tx[1] = Gyro_RANGE;
#    i2c.write( write, tx, 2);
#    wait(0.1);



  #define Accel_CTRL_REGB 0x0D
  #define Accel_CTRL_REGA 0x0E
  #define Accel_SENS      0x02    //00:+-8G, 01:+-6G, 02:+-4G, 03: +-2G
  #define Accel_FILLTER   0xC0    //00:Non, 20:2000Hz, 80:1000Hz, A0:500Hz, C0:100Hz, E0:50Hz
  #char    AccelAddress[] = { 0x00, 0x01, 0x02, 0x03, 0x04, 0x05 };

#	Accel_CTRL_REGC = 
#void AccelSetup(int read, int write )
#{
#char tx[4];
#    //+-6G
#    tx[0] = Accel_CTRL_REGC;
#    tx[1] = Accel_SENS | Accel_FILLTER;
#    i2c.write( write, tx, 2);
#    wait(0.1);
#



	
	#Clear the 'sleep' bit to start the sensor.
#	I2c.write(DevID, Pw, 0)
#	I2c.write(DevID, Pincfg, 2)
	
	#加速度センサの設定 +-4g(-4096_4095), LPF=5Hz
#	cfg = I2c.read(DevID, Accfg) | 0x10 | 0x01
#	I2c.write(DevID, Accfg, cfg)
	#cfg = I2c.read(DevID, Accfg)

	#ジャイロの設定 +-500deg/s
#	cfg = I2c.read(DevID, Gycfg) | 0x08
#	I2c.write(DevID, Gycfg, cfg)
	#cfg = I2c.read(DevID, Gycfg)

#	100.times do
		#加速度
#		xa = I2c.read(DevID, AxL, AxH)
#		ya = I2c.read(DevID, AyL, AyH)
#		za = I2c.read(DevID, AzL, AzH)
		
#		if xa > 32767
#			xa = xa - 65536
#		end
	
#		if ya > 32767
#			ya = ya - 65536
#		end
		
#		if za > 32767
#			za = za - 65536
#		end
		
		#温度
#		templ = I2c.read(DevID, TmL, TmH)
		
#		if templ > 32767
#			templ = templ - 65536
#		end
#		templ = templ / 340.0 + 35.0

		#Gyro
#		xgy = I2c.read(DevID, GxL, GxH)
#		ygy = I2c.read(DevID, GyL, GyH)
#		zgy = I2c.read(DevID, GzL, GzH)

#		if xgy > 32767
#			xgy = xgy - 65536
#		end
		
#		if ygy > 32767
#			ygy = ygy - 65536
#		end
		
#		if zgy > 32767
#			zgy = zgy - 65536
#		end
		
#		Serial.print(0, "T:" + templ.to_s)

#		Serial.print(0, " ACX:" + xa.to_s)
#		Serial.print(0, " ACY:" + ya.to_s)
#		Serial.print(0, " ACZ:" + za.to_s)
		
#		Serial.print(0, " GRX:" + xgy.to_s)
#		Serial.print(0, " GRY:" + ygy.to_s)
#		Serial.println(0, " GRZ:" + zgy.to_s)
		
#		delay(100)
		
#		led(sw)
#		sw = 1 - sw
#	end	

