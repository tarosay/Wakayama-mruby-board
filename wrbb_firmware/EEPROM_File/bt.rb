#################################
# BT通信
#################################
@Mem = MemFile
@Srv = Servo
@S = Serial
@Sy = System
@Con = 4		#Bluetooth接続有無ピン

###################################
# いろいろな初期化
###################################
def init()
	pinMode(@Con, 0)
	@S.begin(0, 115200)		#USBシリアル通信の初期化
	@S.begin(3, 115200)		#
	
	if(@S.available(0) > 0)then
		while(true)do
			@S.read(0)
			if(@S.available(0) <= 0)then
				break
			end
		end
	end
end

###################################
# ファイルローダー起動
###################################
def fileloader()
	#USBからのキー入力あり
	if(@S.available(0)>0)then
		@Sy.fileload()
	end
end
##############################################################################

	# いろいろな初期化
	init()

	Rtc.begin
	Rtc.setDateTime(2015, 7, 19, 3, 30, 0)
	
	cnn = 0
	while(true) do
		delay(10)
		
		#@S.println(0,"Pin4=" + digitalRead(@Con).to_s)

		if(digitalRead(@Con) == 1)then
			if(cnn == 0)then
				@S.println(0,"Bluetooth Connected.")
				year, mon, da, ho, min, sec = Rtc.getDateTime()

				SD.open(0, 'connect.txt', 1)	#mode: 0:Read, 1:Append, 2:New Create
				SD.write(0, 'Bluetooth Connected.: ', 22)
				txt = year.to_s + "/" + mon.to_s + "/" + da.to_s + " " + ho.to_s + ":" + min.to_s + ":" + sec.to_s + 0x0d.chr + 0x0a.chr
				SD.write(0, txt, txt.length)
				SD.close( 0 )
				cnn = 1
			end

			if(@S.available(0)>0)then
				c = @S.read(0).chr
				@S.print(3, c)
				@S.print(0, c)
			end

			if(@S.available(3)>0)then
				c = @S.read(3).chr
				@S.print(0, c)
				@S.print(3, c)
			end
		else
			if(cnn == 1)then
				@S.println(0,"Bluetooth Disconnected.")
				cnn = 0
			end
			fileloader()
		end
	end
