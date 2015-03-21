#################################
# 缶サット　回路Aのセンサプログラム
#################################

#ここには全体で使用する変数を定義しています
@Accel = 0x18				# 0b00011000
@Gyro = 0x6B				# 0b01101011
@Gyro_dps = 0.0175				# 00:0.00875, 10:0.0175, 30:0.07
@APTemp = 0x5D						# 0b01011101

###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	#Serial.begin(2, 9600)		#9600 オープンログのシリアル通信初期化
	Serial.begin(2, 115200)		#テストで115200 オープンログのシリアル通信初期化
	#Serial.begin(3, 115200)		#回路Bとのシリアル通信初期化

	#センサ接続ピンの初期化
	I2c.sdascl( 17, 16 )
	delay(300)
end

###################################
# ファイルローダー起動
###################################
def fileloader()
	#USBからのキー入力あり
	if(Serial.available(0)>0)then
		Sys.fileload()
	end
end
	
###################################
# 加速度センサの初期化
###################################
def initAccel()
	
  # Accel Setup [KXSD9-2050]
	@Accel = 0x18				# 0b00011000
	#Accel_Write = 0x30			# 0b00110000
 	Accel_CTRL_REGC = 0x0C
	Accel_SENS = 0x01				# 00:+-8G, 01:+-6G, 02:+-4G, 03: +-2G
	Accel_FILLTER = 0xC0		# 00:Non, 20:2000Hz, 80:1000Hz, A0:500Hz, C0:100Hz, E0:50Hz
 
	# SENSとFILLTERを設定
	I2c.write(@Accel, Accel_CTRL_REGC, Accel_SENS | Accel_FILLTER)
	delay(100)	#100ms待つ
end

################ ここからMainプログラム #################

	#いろいろな初期化
	init()
	sw = 0

	# 加速度センサの初期化
	initAccel()
	
	#10回繰り返す
	10.times do
	
		Serial.println(0, @Gyro_dps.to_s)
		delay(500)	#500ms待ちます

		#LEDを点滅させます
		led(sw)
		sw = 1 - sw
		
	end
