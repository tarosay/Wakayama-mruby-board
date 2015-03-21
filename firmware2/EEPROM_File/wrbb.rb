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

	#Rtc.setDateTime(2015,3,19,3,16,0)

	14.times do
		led(x)
		x = 1 - x
	
		Serial.print(0,"Hello Wakayama.rb! Ver. ")
		Serial.println(0, Sys.version())
		
		Serial.print(0,"mruby Ver. ")
		Serial.println(0, Sys.version("a"))

		year,mon,da,ho,min,sec = Rtc.getDateTime()
		Serial.println(0,year.to_s + "/" + mon.to_s + "/" + da.to_s + " " + ho.to_s + ":" + min.to_s + ":" + sec.to_s)

		#ファイルローダーチェック
		fileloader()
		delay(1000)
	end

	#cansat-aプログラムの呼び出し
	#Sys.setrun("sample.mrb")
	