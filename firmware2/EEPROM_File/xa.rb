#################################
#
#################################

###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	Serial.begin(2, 115200)		#テストで115200 オープンログのシリアル通信初期化
	Serial.begin(3, 115200)		#回路Bとのシリアル通信初期化
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

	#いろいろな初期化
	init()

	@Sw = 0
	
	while(true)do
	
		while(Serial.available(3) > 0)do	#何か受信があった
			c = Serial.read(3).chr		#1文字取得

			#デバッグ用エコー
			Serial.print(0, c)
		end
		
		#LEDを点滅させます
		led(@Sw)
		@Sw = 1 - @Sw
		
		fileloader()	# ファイルローダー起動
		
		delay(500)
	end
	