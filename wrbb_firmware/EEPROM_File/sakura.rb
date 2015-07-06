# Ruby Board
@Mem = MemFile
@Srv = Servo
@S = Serial
@Sy = System
###################################
# いろいろな初期化
###################################
def init()
	@S.begin(0, 115200)		#USBシリアル通信の初期化
	#S.begin(2, 115200)			#回路Bとのシリアル通信初期化
	#S.begin(3, 9600)			#9600 オープンログのシリアル通信初期化
end

###################################
# ファイルローダー起動
###################################
def fileloader()
	#USBからのキー入力あり
	if(@S.available(0)>0)then
		Music.play 0
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

	delay(1500)
	fileloader()

	PanCake.serial 1 
	
	PanCake.video 0
	PanCake.reset
	PanCake.video 1
	
	PanCake.clear 1

	#スプライトの定義
	Sprite.create(3, 0x92)	#S
	Sprite.create(4, 0x80)	#A
	Sprite.create(5, 0x8a)	#K 		
	Sprite.create(6, 0x95)	#U
	Sprite.create(7, 0x91)	#R
	Sprite.create(8, 0x80)	#A
	Sprite.create(9, 0x89)	#J
	Sprite.create(10, 0x80)	#A
	Sprite.create(11, 0x8c)	#M

	Sprite.user(0xfd, 0, "00033000000ee0003e3333303e311ee33331133003e33e0003e33e3000300300")
	Sprite.create(0, 0xfd)
	Sprite.create(1, 0xfd)
	Sprite.create(2, 0xfd)
	Sprite.create(12, 0xfd)
	Sprite.create(13, 0xfd)
	Sprite.create(14, 0xfd)
	Sprite.create(15, 0xfd)
	
	Sprite.start(0x1a)	#-> 背景を水色にする

    #Sprite.move(9, 10, 10)

	#while(@S.available(0) <= 0)do
	#  delay(10)
	#end

	x = 2
	f = 7
	y = 36
	Sprite.move(3, x, y)
	x = x + f
	Sprite.move(4, x, y)
	x = x + f
	Sprite.move(5, x, y)
	x = x + f
	Sprite.move(6, x, y)
	x = x + f
	Sprite.move(7, x, y)
	x = x + f
	Sprite.move(8, x, y)
	x = x + f + 4
	Sprite.move(9, x, y)
	x = x + f
	Sprite.move(10, x, y)
	x = x + f
	Sprite.move(11, x, y)

	#delay(1000)
	
	srand
	50.times do|j|
	  x1 = rand * 73
	  x2 = rand * 73
	  x3 = rand * 73
	  x4 = rand * 73
	  x5 = rand * 73
	  x6 = rand * 73
	  x7 = rand * 73
	  y1 = rand * 18
	  y2 = rand * 18
	  y3 = rand * 18
	  y4 = rand * 18
	  y5 = rand * 18
	  y6 = rand * 18
	  y7 = rand * 18
      16.times do|i|
        Sprite.move(0x0, x1, y1)
        Sprite.move(0x1, x2, y2)
        Sprite.move(0x2, x3, y3)
        Sprite.move(0xc, x4, y4)
        Sprite.move(0xd, x5, y5)
        Sprite.move(0xe, x6, y6)
        Sprite.move(0xf, x7, y7)
		x1 = x1 + rand * 11 - 5
		x2 = x2 + rand * 11 - 5
		x3 = x3 + rand * 11 - 5
		x4 = x4 + rand * 11 - 5
		x5 = x5 + rand * 11 - 5
		x6 = x6 + rand * 11 - 5
		x7 = x7 + rand * 11 - 5
		y1 = y1 + rand * 4 + 1
		y2 = y2 + rand * 4 + 1
		y3 = y3 + rand * 4 + 1
		y4 = y4 + rand * 4 + 1
		y5 = y5 + rand * 4 + 1
		y6 = y6 + rand * 4 + 1
		y7 = y7 + rand * 4 + 1
		delay(400)
		fileloader()
      end
	end
	
	@Sy.fileload()
	#プログラムの呼び出し
	#Sy.setrun("sample.mrb")
	