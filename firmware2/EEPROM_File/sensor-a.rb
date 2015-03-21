#################################
# 缶サット　回路Aのセンサプログラム
#################################
#ここには全体で使用する変数を定義しています
@Accel = 0x18				# 0b00011000 加速度センサのアドレス
@Accel_vpg = 273		# 00:205, 01:273, 02:410, 03:819 加速度センサの分解能(Value/G)
@Accel_zero = 2048	# 0Gの時の値
@Gyro = 0x6B				# 0b01101011 ジャイロセンサのアドレス
@Gyro_dps = 0.0175	# 00:0.00875, 10:0.0175, 30:0.07 ジャイロセンサの分解能(deg/s)
@APTemp = 0x5D			# 0b01011101 圧力・温度センサのアドレス
@Sw = 0							#LEDの点滅用係数(0 or 1)
@ToTime = 0					#間隔処理のための次に動作する時間が入る
@Interval = 500			#間隔処理の間隔時間が入る
@Token = "token=2686713132-NJHn8ftG5SujEiR3hKxYkgozXila3fFVJMTuPJT&status="	#ツイート用トークン
@Cnt = 0			#タイミングのカウンタ
@Dat = "00"		#日付データが入る
@Tim = "00"		#時刻データが入る
@Lat = "00"		#緯度データが入る
@Lng = "00"		#経度データが入る

###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	#Serial.begin(2, 9600)		#9600 オープンログのシリアル通信初期化
	Serial.begin(2, 115200)		#テストで115200 オープンログのシリアル通信初期化
	Serial.begin(3, 115200)		#回路Bとのシリアル通信初期化

	#センサ接続ピンの初期化(17番SDA, 16番SCL)
	I2c.sdascl( 17, 16 )
	delay(300)	#300ms待つ
end

###################################
# 加速度センサの初期化
###################################
def initAccel()
	
  # Accel Setup [KXSD9-2050]
	#@Accel = 0x18				# 0b00011000
	#Accel_Write = 0x30			# 0b00110000
 	Accel_CTRL_REGC = 0x0C
	Accel_SENS = 0x01				# 00:+-8G, 01:+-6G, 02:+-4G, 03: +-2G
	#@Accel_vpg = 273				# 00:205, 01:273, 02:410, 03:819
	Accel_FILLTER = 0xC0		# 00:Non, 20:2000Hz, 80:1000Hz, A0:500Hz, C0:100Hz, E0:50Hz
 
	# SENSとFILLTERを設定
	I2c.write(@Accel, Accel_CTRL_REGC, Accel_SENS | Accel_FILLTER)
	delay(100)	#100ms待つ
end

###################################
# ジャイロセンサの初期化
###################################
def initGyro()

	# Gyro Setup [L3GD20]
	#@Gyro = 0x6B				# 0b01101011
	#Gyro_Write = 0xD4				# 0b11010110
	#Gyro_WHO_AM_I = 0x0F
	Gyro_CTRL_REG1 = 0x20		# Control register
	Gyro_ENABLE = 0x0F
	Gyro_CTRL_REG4 = 0x23		# Control register
	Gyro_CTRL_REG3 = 0x22		# Control register
	Gyro_RANGE = 0x10				# 00:+-250dps, 10:+-500dps, 30:+-2000dps
	#@Gyro_dps = 0.0175				# 00:0.00875, 10:0.0175, 30:0.07

	#val = I2c.read( Gyro, Gyro_WHO_AM_I)
	#Serial.println(0, "Gyro Who am I? = " + val.to_s)

	# Turn on all axes, disable power down
	I2c.write(@Gyro, Gyro_CTRL_REG1, Gyro_ENABLE)
	delay(100)	#100ms待つ
	# +-500dps
	I2c.write(@Gyro, Gyro_CTRL_REG4, Gyro_RANGE)
	delay(100)	#100ms待つ
end

###################################
# ファイルローダー起動
###################################
def fileloader()
	#USBからのキー入力あり
	if(Serial.available(0)>0)then
		#内蔵ファイルローダーを呼ぶ
		Sys.fileload()
	end
end

###################################
# 次の設定時間を計算します
###################################
def nextTime()
		@ToTime = @ToTime + @Interval
		#次の設定時間を計算します
		while(millis() > @ToTime)do
			@ToTime = @ToTime + @Interval
			fileloader()	# ファイルローダー起動
			delay(1)	#1ms待ちます
		end
end

################ ここからMainプログラム #################

	#いろいろな初期化
	init()

	# 加速度センサの初期化
	initAccel()
	
	# ジャイロセンサの初期化
	initGyro()

	#次の動作時間をセットする
	@ToTime = millis() + @Interval
	
	#無限にループします
	while(true) do
		
		#間隔待ち。予定の時間になるまで待っている
		while(millis() < @ToTime)do
			delay(1)	#1ms待ちます
		end

		#次の設定時間を計算します
		nextTime()
		
		#SDメモリに時間を出力
		Serial.print(0, @ToTime.to_s + ",")
		Serial.print(2, @ToTime.to_s + ",")
		
		#加速度を取得します --------------------------------------
		#Address 0x00, 0x01, 0x02, 0x03, 0x04, 0x05
		v0 = I2c.read( @Accel, 1, 0)
		v1 = I2c.read( @Accel, 3, 2)
		v2 = I2c.read( @Accel, 5, 4)
		x = ((v0 / 16).truncate - @Accel_zero) / @Accel_vpg
		y = ((v1 / 16).truncate - @Accel_zero) / @Accel_vpg
		z = ((v2 / 16).truncate - @Accel_zero) / @Accel_vpg
		#SDメモリに加速度を出力します
		Serial.print(0, x.to_s + "," + y.to_s + "," + z.to_s)
		Serial.print(2, x.to_s + "," + y.to_s + "," + z.to_s)
		#---------------------------------------------------------
		
		#角速度を取得します --------------------------------------
		#Address 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D
		v0 = I2c.read( @Gyro, 0x28, 0x29)
		v1 = I2c.read( @Gyro, 0x2A, 0x2B)
		v2 = I2c.read( @Gyro, 0x2C, 0x2D)

		if v0 > 32767
			v0 = v0 - 65536
		end

		if v1 > 32767
			v1 = v1 - 65536
		end

		if v2 > 32767
			v2 = v2 - 65536
		end
		
		v0 = v0 * @Gyro_dps
		v1 = v1 * @Gyro_dps
		v2 = v2 * @Gyro_dps
		#SDメモリに角速度を出力します
		Serial.println(0, "," + v0.to_s + "," + v1.to_s + "," + v2.to_s )
		Serial.println(2, "," + v0.to_s + "," + v1.to_s + "," + v2.to_s )
		#---------------------------------------------------------
		
		#30sec毎
		if(@Cnt == 0)then
			@Dat = "00"
			@Tim = "00"
			100.times do
				#dateの取得
				a = Net.date()
				if(a != "00")then
					@Dat = a
				
					#時間の取得
					a = Net.time()
					if(a != "00")then
						@Tim = a
					end
				end
				delay(50)
				if((@Dat != "00")&&(@Tim != "00"))then
					break
				end
				if(Serial.available(0)>0)then
					#内蔵ファイルローダーを呼ぶ
					Sys.fileload()
				end
			end

			#緯度の取得(1分(60000ms)間GPS衛星を探す)
			@Lat = Net.lat(60000)
			#取得した値が 0～50の範囲であれば正常とする。(日本だから)
			if((@Lat != "00") && (@Lat.to_f > 0) && (@Lat.to_f < 50))then
				#経度の取得(1分(60000ms)間GPS衛星を探す)
				@Lng = Net.lng(60000)
				#取得した値が0～155の範囲であれば正常とする。(日本だから)
				if((@Lng == "00") || (@Lng.to_f < 0) || (@Lng.to_f > 155))then
					@Lng = "00"
				end
			else
				@Lat = "00"
			end
		
			#緯度経度が取得できなかったときは、3Gシールドを再起動する
			if((@Lat == "00") || (@Lng == "00"))then
				Net.restart()
				delay(10000)
			end

			#USBシリアルに出力
			Serial.println(0, @ToTime.to_s + "," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",")
			#回路Bに送信する
			Serial.print(3, "!," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",!")
			#mesの内容をツイートする
			#mes = "Sensor: " + @ToTime.to_s + " " + @Dat + " " + @Tim + " " + @Lng + " " + @Lat + " #cansatkainan"
			mes = "Cansat: " + @ToTime.to_s + " " + @Dat + " " + @Tim + " " + @Lng + " " + @Lat + " #cansatkainan"

			Serial.println(0, mes)
			res = Net.httppost("arduino-tweet.appspot.com","update",80,"",@Token + mes) 
			#if(res.to_s == "OK")then
			#	Serial.println(0, res.to_s)
			#else
			#	Serial.println(0, "Tweet NG")
			#	Net.getmrb("www.geocities.jp","/cansatkainan01/dummy.mrb",80)
			#	#Net.restart()
			#end 
		end
		
		#LEDを点滅させます
		led(@Sw)
		@Sw = 1 - @Sw
		
		# 60*0.5sec毎のタイミングつくり
		@Cnt = @Cnt + 1
		if(@Cnt == 60)then
			@Cnt = 0
		end

	end
	#終わり
