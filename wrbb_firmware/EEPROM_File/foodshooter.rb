#################################
# フードシュータ
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
	delay(1)
end

################ ここからMainプログラム #################

	#いろいろな初期化
	init()

	#無限にループします
	while(true) do
		led(0)
		#Srv.write(0, 0)
		if(@S.available(0)>0)then
			r = @S.read(0)
			if(r == 0x30)then
				led(1)
				@Srv.write(0, 0)
				delay(1000)
				
				16.times {|i|
					@Srv.write(0, i*10)
					delay(1000)
				}				
				
				#@Srv.write(0, 160)
			else
				@Sy.fileload()
			end
		end	
	end
