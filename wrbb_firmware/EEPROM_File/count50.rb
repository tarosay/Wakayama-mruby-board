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

init()

50.times do|i|
	@S.print(0, i.to_s)
	delay(250)
	led(i % 2)
end



