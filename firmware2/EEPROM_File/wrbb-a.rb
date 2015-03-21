#################################
# 缶サット　回路Aの起動プログラム
#################################
#ここには全体で使用する変数を定義しています
@Sw = 1

###################################
# USB通信の初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
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
################ ここからMainプログラム #################

	#LEDの点灯
	led(@Sw)

	#USB通信の初期化
	init()

	#15回繰り返す
	15.times do
		Serial.println(0,"Hello CanSat-A!")
		
		#ファイルローダーチェック
		fileloader()
		
		#1000ms待つ
		delay(1000)
	end

	#cansat-aプログラムの呼び出し
	Sys.setrun("cansat-a.mrb")
	#Sys.setrun("sensor-a.mrb")
	
	#終わり
	