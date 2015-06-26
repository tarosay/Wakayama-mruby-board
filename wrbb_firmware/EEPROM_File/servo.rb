#################################
# サーボテスト
# GWS S03N 2BBMG
# オレンジ・・・信号線
# 赤・・・・・・3.3V
# 茶・・・・・・GND
#################################
@Mem = MemFile
@Srv = Servo
@S = Serial
@Sy = System

@SrvPin = 8

###################################
# いろいろな初期化
###################################
def init()
	@S.begin(0, 115200)		#USBシリアル通信の初期化

	#8番ピンをサーボ制御ピンに設定
	@Srv.attach(0, @SrvPin)
	@Srv.write(0, 0) #0度にする
end

###################################
# ファイルローダー起動
###################################
def fileloader()
	#USBからのキー入力あり
	if(@S.available(0)>0)then
		#内蔵ファイルローダーを呼ぶ
		@Sy.fileload()
	end
end


################ ここからMainプログラム #################

#いろいろな初期化
init()

ss = 1
g_pos = 0
g_inc = 15

#無限にループします
while(true) do
	delay(250)
	led(ss)
	ss = 1 - ss
	g_pos = g_pos + g_inc
	@Srv.write(0, g_pos)

	if(g_pos >= 180 || g_pos <= 0)then
		g_inc = g_inc * -1
	end
	fileloader()	# ファイルローダー起動
end
