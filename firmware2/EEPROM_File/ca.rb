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

	@Dat = "2014/07/12"
	@Tim = "01:30:05"
	@Lat = "00"
	@Lng = "00"
	@Sw = 0
	
	#無限にループします
	while(true) do
	
		delay(500)

		Serial.println(0, @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",")
		Serial.println(2, @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",")

		Serial.print(0, "!," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",!")
		Serial.print(3, "!," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",!")
		
		#LEDを点滅させます
		led(@Sw)
		@Sw = 1 - @Sw
		
		fileloader()	# ファイルローダー起動
	end
	