#################################
# 缶サット　回路Aのメインプログラム
#################################
#ここには全体で使用する変数を定義しています
@Dat = "00"		#日付データが入る
@Tim = "00"		#時刻データが入る
@Lat = "00"		#緯度データが入る
@Lng = "00"		#経度データが入る
@Sw = 0				#LEDの点滅用係数(0 or 1)
@Token = "token=2686713132-NJHn8ftG5SujEiR3hKxYkgozXila3fFVJMTuPJT&status="	#ツイート用トークン
@Cnt = 0			#タイミングのカウンタ
@ToTime = 0		#間隔処理のための次に動作する時間が入る
@Interval = 10000	#間隔処理の間隔時間が入る

###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	#Serial.begin(2, 9600)		#9600 オープンログのシリアル通信初期化
	Serial.begin(2, 115200)		#テストで115200 オープンログのシリアル通信初期化
	Serial.begin(3, 115200)		#回路Bとのシリアル通信初期化
end

###################################
# 3Gシールドの初期化
###################################
def init3g()
	#一度電源を切る
	Net.shutdown()
	
	#3回トライする
	3.times do
		#3Gシールドの通信速度4800bpsで動作を開始させる
		Serial.println(0, "3G-Sheild Power On Now")
		Serial.println(2, "3G-Sheild Power On Now")
		delay(100)	#100ms待つ
		
		#インターネットと4800bpsの速度で通信する用に設定
		if(Net.begin(4800) == 0)then
			#動作開始したら 1を返す
			return 1
		end
	end
	#3回トライしても動作開始できなかったら 0を返す
	return 0
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

###################################
# 次の設定時間を計算します
###################################
def nextTime()
		@ToTime = @ToTime + @Interval
		#次の設定時間を計算します
		while(millis() > @ToTime)do
			@ToTime = @ToTime + @Interval
			fileloader()	# ファイルローダー起動
			delay(1)	#1ms待ちます
		end
end

################ ここからMainプログラム #################

	#いろいろな初期化
	init()

	#3Gシールドの動作開始で 0が返ってきたらエラーにする
	if(init3g() == 0)then
		Serial.println(0, "3G-Sheild Power On Error")
		Serial.println(2, "3G-Sheild Power On Error")
		delay(100)	#100ms待つ
		
		#無限ループしている
		while(true)do
			#ファイルローダーを呼び出すべきか調べる
			fileloader()
			
			#LEDを点滅させる
			led(@Sw)
			@Sw = 1 - @Sw
			delay(100)	#100ms待つ
		end
	end
	
	@ToTime = millis()
	#次の動作時間をセットする
	nextTime()

	x = 1
	#無限ループしている
	while(true)do
	
		#30sec毎
		if(@Cnt == 0)then
			Serial.println(0, "http://www.geocities.jp/cansatkainan01/sensor-a.mrb")
			Serial.println(2, "http://www.geocities.jp/cansatkainan01/sensor-a.mrb")

			#http://www.geocities.jp/cansatkainan01/からプログラムをダウンロードする
			x = Net.getmrb("www.geocities.jp","/cansatkainan01/sensor-a.mrb",80)

			#x=0だったら成功している
			if(x == 0)then
				#sensor-a.mrbの実行セット
				Sys.setrun("sensor-a.mrb")
				delay(100)	#100ms待つ
				#"Success load sensor-a.mrb #cansatkainan"とツイートする
				Serial.println(0, "Success load sensor-a.mrb")
				Serial.println(2, "Success load sensor-a.mrb")
				mes = "Success load sensor-a.mrb #cansatkainan"
				res = Net.httppost("arduino-tweet.appspot.com","update",80,"",@Token + mes) 

				#今走っているプログラムを終了させる
				Sys.exit()
			else
				Serial.println(0, "Failed load sensor-a.mrb")
				Serial.println(2, "Failed load sensor-a.mrb")
			end
		end

		@Dat = "00"
		@Tim = "00"
		100.times do
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
		
		#if((@Lat == "00") || (@Lng == "00"))then
		#	Net.restart()
		#	Serial.println(0, "Net restart")
		#	Serial.println(2, "Net restart")
		#	delay(5000)
		#end

		#USBシリアルに出力
		Serial.println(0, @ToTime.to_s + "," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",")
		#メモリカードに出力する
		Serial.println(2, @ToTime.to_s + "," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",")
		#回路Bに送信する
		Serial.print(3, "!," + @Dat + "," + @Tim + "," + @Lat + "," + @Lng + ",!")
		
		
		#30sec毎
		if(@Cnt == 1)then
			mes = "Cansat: " + @ToTime.to_s + " " + @Dat + " " + @Tim + " " + @Lng + " " + @Lat + " #cansatkainan"
			Serial.println(0, mes)
			Serial.println(2, mes)
			#mesの内容をツイートする
			res = Net.httppost("arduino-tweet.appspot.com","update",80,"",@Token + mes) 
			#OKが返ってきたらOKをログに書く、そうでないときはTweet NGと書く
			if(res.to_s == "OK")then
				Serial.println(0, res.to_s)
				Serial.println(2, res.to_s)
			else
				Serial.println(0, "Tweet NG")
				Serial.println(2, "Tweet NG")
				#うまくツイートできないときは、試しにgetmrbコマンドを走らせている(気休め程度の意味)
				Net.getmrb("www.geocities.jp","/cansatkainan01/dummy.mrb",80)
				#Net.restart()
			end 
		end
		
		#間隔待ち。予定の時間になるまで待っている
		while(millis() < @ToTime)do
			#ファイルローダーを呼び出すべきか調べる
			fileloader()
			delay(1)	#1ms待ちます
		end

		#次の動作時間をセットする
		nextTime()

		#LEDを点滅させる
		led(@Sw)
		@Sw = 1 - @Sw
		
		# cを0,1,2,0,1,2,... と変えていく。0の時にネットにプログラムを見に行く。
		@Cnt = @Cnt + 1
		if(@Cnt == 3)then
			@Cnt = 0
		end
	end
	#終わり

