Serial.begin(2, 9600)		#9600 オープンログのシリアル通信初期化
	#Serial.begin(2, 115200)		#テストで115200 オープンログのシリアル通信初期化
	
10.times do
	Serial.println(2, "TESTTEST")
 end
 