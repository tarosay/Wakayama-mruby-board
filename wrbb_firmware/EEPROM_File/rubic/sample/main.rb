#!mruby
#ここには全体で使用する変数を定義しています
@Mem = MemFile
@Srv = Servo
@S = Serial
@Sy = System
@R = Rtc
@Sw = 0				#LEDの点滅用係数(0 or 1)
@Usb = 0
@UartReadNowFlg = 0
@UartTimeOver = 0
@COMMAND_TIME_OVER = 500
@UartChar = ""

###################################
# いろいろな初期化
###################################
def init()
	@S.begin(@Usb, 115200)		#USBシリアル通信の初期化
	#Serial.begin(2, 9600)
	#Serial.begin(2, 115200)
	#Serial.begin(3, 115200)
	
	@R.begin()	#リアルタイムクロック起動
end
################ ここからMainプログラム #################

	#いろいろな初期化
	init()

	@S.println(@Usb, "Hello mruby")

	delay(400)

	#終わり
