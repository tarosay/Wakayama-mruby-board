#################################
# 
#################################
#ここには全体で使用する変数を定義しています
@Token = "token=2686713132-NJHn8ftG5SujEiR3hKxYkgozXila3fFVJMTuPJT&status="	#ツイート用トークン

	Serial.begin(0, 115200)		#USBシリアル通信の初期化

	#次の動作時間をセットする
	@Interval = 30000
	@ToTime = millis() + @Interval
	@Cnt = 0
	@Lat = "00"
	@Lng = "00"
	
	240.times do
		@Dat = "00"
		@Tim = "00"
		while(true) do
			#dateの取得
			a = Net.date()
			if(a != "00")then
				@Dat = a
				
				#時間の取得
				a = Net.time()
				if(a != "00")then
					@Tim = a
				end
			end
			delay(50)
			if((@Dat != "00")&&(@Tim != "00"))then
				break
			end
			if(Serial.available(0)>0)then
				#内蔵ファイルローダーを呼ぶ
				Sys.fileload()
			end
		end
		
		#緯度の取得(1分(60000ms)間GPS衛星を探す)
		@Lat = Net.lat(60000)
		#取得した値が 0～50の範囲であれば正常とする。(日本だから)
		if((@Lat != "00") && (@Lat.to_f > 0) && (@Lat.to_f < 50))then
			#経度の取得(1分(60000ms)間GPS衛星を探す)
			@Lng = Net.lng(60000)
			#取得した値が0～155の範囲であれば正常とする。(日本だから)
			if((@Lng == "00") || (@Lng.to_f < 0) || (@Lng.to_f > 155))then
				@Lng = "00"
			end
		else
			@Lat = "00"
		end
		
		if((@Lat == "00") || (@Lng == "00"))then
			Net.restart()
		end
		
		mes = @Cnt.to_s + " " + @ToTime.to_s + " " + @Dat + " " + @Tim + " " + @Lng + " " + @Lat + " #cansatkainan"
		Serial.println(0, mes)
		@Cnt = @Cnt + 1
		
		res = Net.httppost("arduino-tweet.appspot.com","update",80,"",@Token + mes) 
		Serial.println(0, res.to_s)

		#間隔待ち
		while(millis() < @ToTime)do
			if(Serial.available(0)>0)then
				#内蔵ファイルローダーを呼ぶ
				Sys.fileload()
			end
			delay(1)	#1ms待ちます
		end

		@ToTime = @ToTime + @Interval
		#次の設定時間を計算します
		while(millis() > @ToTime)do
			@ToTime = @ToTime + @Interval
			delay(1)	#1ms待ちます
		end
	end
	