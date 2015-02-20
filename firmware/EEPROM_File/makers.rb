#################################
# メイカーズバザール大阪
#################################
#ここには全体で使用する変数を定義しています
@APTemp = 0x5D			# 0b01011101 圧力・温度センサのアドレス
@Sw = 0				#LEDの点滅用係数(0 or 1)
@ToTime = 0						#間隔処理のための次に動作する時間が入る
@Interval = 500				#間隔処理の間隔時間が入る

###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化

	#センサ接続ピンの初期化(17番SDA, 16番SCL)
	I2c.sdascl( 17, 16 )
	delay(300)	#300ms待つ
end

###################################
# 気圧と温度センサの初期化
###################################
def initTempPress()

	#@APTemp = 0x5D						# 0b01011101
	#APTemp_Write    0xBA    //0b10111010
	APTemp_WHO_AM_I = 0x0F
	APTemp_CTRL_REG1 = 0x20	# Control register
	APTemp_SAMPLING = 0xA0	# A0:7Hz, 90:1Hz

	val = I2c.read( @APTemp, APTemp_WHO_AM_I )
	Serial.println(0, "APTemp Who am I? = " + val.to_s)

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

	# 気圧と温度センサの初期化
	initTempPress()

	@ToTime = millis() + @Interval
	#次の動作時間をセットする
	nextTime()
	
	#無限にループします
	while(true) do

		#間隔待ち
		while(millis() < @ToTime)do
			delay(1)	#1ms待ちます
		end

		#次の動作時間をセットする
		nextTime()

		#気圧を取得します --------------------------------------
		#Address 0x28, 0x29, 0x2A, 0x2B, 0x2C
		v0 = I2c.read( @APTemp, 0x28, 0x29)
		v1 = I2c.read( @APTemp, 0x2A)
		a = v0 + v1 * 65536
		a = a / 4096.0		# hPa単位に直す
		Serial.println(0, "Pressurea= " + a.to_s)
		#---------------------------------------------------------

		#温度を取得します --------------------------------------
		v2 = I2c.read( @APTemp, 0x2B, 0x2C)
		if v2 > 32767
			v2 = v2 - 65536
		end
		t = v2 / 480.0 + 42.5
		Serial.println(0, "Temperature= " + t.to_s)
		#---------------------------------------------------------
		
		#LEDを点滅させます
		led(@Sw)
		@Sw = 1 - @Sw
		
		fileloader()	# ファイルローダー起動
	end
