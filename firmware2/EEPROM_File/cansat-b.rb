#################################
# 缶サット　回路Bのセンサプログラム
#################################
#ここには全体で使用する変数を定義しています
@Accel = 0x19				# 0b00011000 加速度センサのアドレス
@Accel_vpg = 273		# 00:205, 01:273, 02:410, 03:819 加速度センサの分解能(Value/G)
@Accel_zero = 2048	# 0Gの時の値
@Gyro = 0x6A				# 0b01101011 ジャイロセンサのアドレス
@Gyro_dps = 0.0175	# 00:0.00875, 10:0.0175, 30:0.07 ジャイロセンサの分解能(deg/s)
@APTemp = 0x5D			# 0b01011101 圧力・温度センサのアドレス
@Dat = "00"		#日付データが入る
@Tim = "00"		#時刻データが入る
@Lat = "00"		#緯度データが入る
@Lng = "00"		#経度データが入る
@Sw = 0				#LEDの点滅用係数(0 or 1)
@ToTime = 0						#間隔処理のための次に動作する時間が入る
@Interval = 500				#間隔処理の間隔時間が入る
@UartChar = ""				#回路Aからの受信データが入る
@UartReadNowFlg = 0		#回路Aからデータを受信中フラグ
@UartTimeOver = 0			#回路Aからのデータを受信している時間
@COMMAND_TIME_OVER = 250	#回路Aからのデータ受信タイムアウト時間
@OpenLogCnt = 0		#OpenLogを新規ファイルに更新するタイミングカウンタ

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
	
	##OpenLogの初期化
	#Serial.print(2, 0x1A.chr + 0x1A.chr + 0x1A.chr)	#コマンドモードに切り替え
	#delay(500)																			#500ms待つ
	#Serial.println(2, "reset")											#初期化する
	#delay(500)																			#500ms待つ

end

###################################
# OpenLogをリセットして書き込みファイルを更新します
###################################
def openlogreset()
	Serial.print(2, 0x1A.chr + 0x1A.chr + 0x1A.chr)		#コマンドモードに切り替え
	delay(100)		#100ms待つ
	Serial.println(2, "reset")	#初期化する
	delay(100)		#100ms待つ
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
# 気圧と温度センサの初期化
###################################
def initTempPress()

	@APTemp = 0x5D						# 0b01011101
	#APTemp_Write    0xBA    //0b10111010
	#APTemp_WHO_AM_I = 0x0F
	APTemp_CTRL_REG1 = 0x20	# Control register
	APTemp_SAMPLING = 0xA0	# A0:7Hz, 90:1Hz

	#val = I2c.read( APTemp, APTemp_WHO_AM_I )
	#Serial.println(0, "APTemp Who am I? = " + val.to_s)

	# 7Hz
	I2c.write(@APTemp, APTemp_CTRL_REG1, APTemp_SAMPLING)
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
# 受信した内容を取得します
# 開始コード: '!'  終了コード: '!'
###################################
def readData()

	#回路Aからのデータ受信時にカウントされる
	if(@UartReadNowFlg == 1)then
		@UartTimeOver = @UartTimeOver + 1
		#終端の'!'コードが送られてこなくて、時間切れの処理
		if(@UartTimeOver > @COMMAND_TIME_OVER)then
			Serial.println(0, "Timeout Command Acceptance." )
			@UartChar = ""				#入力データを空にする
			@UartReadNowFlg = 0		#受信中止
			@UartTimeOver = 0			#時間カウントの初期化
		end
	end

	while(Serial.available(3) > 0)do	#何か受信があった
		c = Serial.read(3).chr		#1文字取得

		#デバッグ用エコー
		#Serial.print(0, c)

		if((@UartChar.length == 0) && (c == "!"))then		#'!'スタートコードという設定
			#データ開始を意味する'!'を受信した
			@UartChar = c					#最初の1文字を入れる
			@UartReadNowFlg = 1		#受信開始
			@UartTimeOver = 0			#タイムオーバーカウンタを0にする

		elsif((@UartReadNowFlg == 1) && (c == "!") && (@UartChar.length > 0))then
			#データ終了を意味する'!'を受信した
			@UartChar = @UartChar + c		#最後の1データを追加する
			@UartReadNowFlg = 0					#受信中止

			#受信内容をUSBシリアルに出力
			Serial.println(0, "GET: " + @UartChar)

			#受信データをカンマ区切りで分割する
			recv = @UartChar.split(",")
			
			#4つより多く分割できていれば、日時と緯度経度が受信できたと考える
			if(recv.length > 4)then
				#それぞれを代入する
				@Dat = recv[1]
				@Tim = recv[2]
				@Lat = recv[3]
				@Lng = recv[4]
			end
			
			#受信データを空にする
			@UartChar = ""

		elsif(@UartReadNowFlg == 1)then
			#データ終了コード'!'では無いので、受信データを追加する
			@UartChar = @UartChar + c
		end
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

	# 気圧と温度センサの初期化
	initTempPress()

	#次の動作時間をセットする
	nextTime()
	
	#無限にループします
	while(true) do
	
		#データ受信チェック
		readData()

		#間隔待ち
		while(millis() < @ToTime)do
			#データ受信チェック
			readData()
			delay(1)	#1ms待ちます
		end

		#SDメモリに日時と緯度経度を出力します
		Serial.print(2, @ToTime.to_s + "," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",")

		#次の動作時間をセットする
		nextTime()
		
		#加速度を取得します --------------------------------------
		#Address 0x00, 0x01, 0x02, 0x03, 0x04, 0x05
		v0 = I2c.read( @Accel, 1, 0)
		v1 = I2c.read( @Accel, 3, 2)
		v2 = I2c.read( @Accel, 5, 4)
		x = ((v0 / 16).truncate - @Accel_zero) / @Accel_vpg
		y = ((v1 / 16).truncate - @Accel_zero) / @Accel_vpg
		z = ((v2 / 16).truncate - @Accel_zero) / @Accel_vpg
		#SDメモリに加速度を出力します
		Serial.print(2, x.to_s + "," + y.to_s + "," + z.to_s + ",")
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
		Serial.print(2, v0.to_s + "," + v1.to_s + "," + v2.to_s + ",")
		#---------------------------------------------------------
		
		#気圧を取得します --------------------------------------
		#Address 0x28, 0x29, 0x2A, 0x2B, 0x2C
		v0 = I2c.read( @APTemp, 0x28, 0x29)
		v1 = I2c.read( @APTemp, 0x2A)
		a = v0 + v1 * 65536
		a = a / 4096.0		# hPa単位に直す
		#SDメモリに気圧を出力します
		Serial.print(2, a.to_s + ",")
		#---------------------------------------------------------
		
		#温度を取得します --------------------------------------
		v2 = I2c.read( @APTemp, 0x2B, 0x2C)
		if v2 > 32767
			v2 = v2 - 65536
		end
		t = v2 / 480.0 + 42.5
		#SDメモリに温度を出力します
		Serial.println(2, t.to_s + ",")
		#---------------------------------------------------------
		
		#LEDを点滅させます
		led(@Sw)
		@Sw = 1 - @Sw
		
		##240回(2分)ごとにログファイルを更新します
		#@OpenLogCnt = @OpenLogCnt + 1
		#if(@OpenLogCnt >= 240)
		#	@OpenLogCnt = 0
		#	openlogreset()
		#end
		
		fileloader()	# ファイルローダー起動
	end

	#終わり
