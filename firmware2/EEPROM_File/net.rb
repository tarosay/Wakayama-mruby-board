#################################
# 3Gシールとのテスト
#################################


###################################
# いろいろな初期化
###################################
def init()
	Serial.begin(0, 115200)		#USBシリアル通信の初期化
	#Serial.begin(2, 9600)			#9600 オープンログのシリアル通信初期化
	Serial.begin(2, 115200)			#テストで115200 オープンログのシリアル通信初期化
	Serial.begin(3, 115200)		#回路Bとのシリアル通信初期化

	#I2Cピンの設定
	I2c.sdascl( 17, 16 )
	delay(300)
end

###################################
# 3Gシールドの初期化
###################################
def init3g()
	Net.shutdown()
	5.times do
		if(Net.begin(4800)==0)then
			return 1
		end
	end
	return 0
end

################ ここからMainプログラム #################

	init()

	a = init3g()

	if(a==0)then
		Sys.exit()
	end
	
	#https://dl.dropboxusercontent.com/u/14702102/mrb/test.mrb
	#https://dl.dropboxusercontent.com/u/14702102/mrb/test1
	
	#Net.getmrb("dl.dropboxusercontent.com","/u/14702102/mrb/test.mrb",448,1)
	
	#Serial.println(2, "http://dl.dropboxusercontent.com/u/14702102/mrb/test.mrb")
	#Net.getmrb("dl.dropboxusercontent.com","/u/14702102/mrb/test.mrb",80,0)
	
	while(true)do
	
		Serial.println(2, "http://dl.dropboxusercontent.com/u/14702102/mrb/count50.mrb")
		x = Net.getmrb("dl.dropboxusercontent.com","/u/14702102/mrb/count50.mrb",80,0)
		
		if(x == 0)then
			Sys.setrun("count50.mrb")
			Sys.exit()
		end

		delay(100)
	end
	
