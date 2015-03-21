#################################
# OpenLog
# [ctrl+Z][ctrl+Z][ctrl+Z]で記録を中断してコマンドモードにはいる
# baud ボーレート設定 115200x と打てば、ボーレートが変わってホールドする。
# reset コマンドモードを抜けて新規ファイルに記録開始する
#################################
#ここには全体で使用する変数を定義しています

###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	#Serial.begin(2, 9600)		#9600 オープンログのシリアル通信初期化
	Serial.begin(2, 115200)		#テストで115200 オープンログのシリアル通信初期化
end

################ ここからMainプログラム #################

	#いろいろな初期化
	init()

	c = 0
	#無限にループします
	while(true) do

		if(Serial.available(0) > 0)then
			c = Serial.read(0)
			Serial.print(2, c.chr)
			
			if(c.chr == "B")then
				Serial.begin(2, 9600)
			elsif(c.chr == "N")then
				Serial.begin(2, 115200)
			elsif(c.chr == "M")then
				Sys.fileload()
			end
		end
	
		if(Serial.available(2) > 0)then
			c = Serial.read(2)
			Serial.print(0, c.chr)
		end
	
		delay(10)
	
	end