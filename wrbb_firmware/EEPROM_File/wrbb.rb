# Ruby Board


###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	#Serial.begin(2, 115200)			#回路Bとのシリアル通信初期化
	#Serial.begin(3, 9600)			#9600 オープンログのシリアル通信初期化
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

  x = 1
	led(x)

	#いろいろな初期化
	init()

#	while(true)do
		if(Serial.available(0)>0)then
			while(true)do
				Serial.read(0)
				if(Serial.available(0) <= 0)then
					break
				end
			end
#			break
		end
#	end


	4.times do
		led(x)
		x = 1 - x
	
		Serial.println(0,"Hello Wakayama.rb!")
		
		#ファイルローダーチェック
		fileloader()
		delay(1000)
	end

	Serial.println(0,"Wakayama.rb board Ver. " + Sys.version() + " mruby Ver. " + Sys.version(1) )

	#プログラムの呼び出し
	#Sys.setrun("sample.mrb")
	