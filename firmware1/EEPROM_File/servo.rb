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
  ss = 1
	g_pos = 0
	g_inc = 15

  pinMode(7, 0)
	Srv.attach(0, 8)
	Srv.write(0, g_pos)

	#無限にループします
	while(true) do
		delay(250)
	  led(ss)
		ss = 1 - ss
	 #if(digitalRead(7) == 0)then
			g_pos = g_pos + g_inc
      Srv.write(0, g_pos)
				
      if(g_pos >= 180 || g_pos <= 0)then
        g_inc = g_inc * -1
			end
    #end
		fileloader()	# ファイルローダー起動
	end
