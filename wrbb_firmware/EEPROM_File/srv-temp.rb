#################################
# サーボテスト
# GWS S03N 2BBMG
# オレンジ・・・信号線
# 赤・・・・・・3.3V
# 茶・・・・・・GND
#################################

###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	
  #8番ピンをサーボ制御ピンに設定
	Srv.attach(0, 8)
	Srv.write(0, 0) #0度にする
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

################ ここからMainプログラム #################

	#いろいろな初期化
	init()
	sw = 1
	h = 1
	#無限にループします
	while(true) do
	 Serial.println("TEST")
	 
	#LEDを点滅させます
		led(sw)
		sw = 1 - sw

		ang = ang + h * 10
		
		if(ang > 180)then
			h = -1
			ang = 180
		end
		
		if(ang < 0)then
			h = 1
		  ang = 0
		end
    
		Srv.write(0, ang)
	
		delay(250)
		
		fileloader()	# ファイルローダー起動
	end
