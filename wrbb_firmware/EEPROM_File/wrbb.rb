# coding: utf-8
# Sample
@Mem = MemFile
@Srv = Servo
@S = Serial
@Sy = System

# いろいろな初期化
def init()
	@S.begin(0, 115200)		#USBシリアル通信の初期化
end

# ファイルローダー起動
def fileloader()
	#USBからのキー入力あり
	if(@S.available(0)>0)then
		@Sy.fileload()
	end
end

  x = 1
  led(x)

	#いろいろな初期化
	init()

	if(@S.available(0) > 0)then
		while(true)do
			@S.read(0)
			if(@S.available(0) <= 0)then
				break
			end
		end
	end

	#Rtc.setDateTime(2015,5,11,21,40,0)

	10.times do|i|
		led(x)
		x = 1 - x
	
		@S.print(0,i.to_s + " Hello Wakayama.rb! Ver. ")
		@S.println(0, @Sy.version())
		
		@S.print(0,"mruby Ver. ")
		@S.println(0, @Sy.version(0))

		#year,mon,da,ho,min,sec = Rtc.getDateTime()
		#S.println(0,year.to_s + "/" + mon.to_s + "/" + da.to_s + " " + ho.to_s + ":" + min.to_s + ":" + sec.to_s)

		#ファイルローダーチェック
		fileloader()
		delay(500)
	end

	#プログラムの呼び出し
	#Sy.setrun("sample.mrb")
	