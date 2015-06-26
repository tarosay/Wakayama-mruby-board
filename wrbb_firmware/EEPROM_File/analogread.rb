# coding: utf-8
Mem = MemFile
Srv = Servo
S = Serial
Sy = System

# いろいろな初期化
def init()
	S.begin(0, 115200)		#USBシリアル通信の初期化
end

# ファイルローダー起動
def fileloader()
	#USBからのキー入力あり
	if(S.available(0)>0)then
		Sy.fileload()
	end
end

init()

#Read AD
while(true)do
	S.print(0, analogRead(14).to_s + ", ")
	S.print(0, analogRead(15).to_s + ", ")
	S.print(0, analogRead(16).to_s + ", ")
	S.println(0, analogRead(17).to_s)
	delay(500)
	fileloader()
end	
