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
	Sprite.create(0, 0x92)	#S
	Sprite.create(1, 0x80)	#A
	Sprite.create(2, 0x8a)	#K 		
	Sprite.create(3, 0x95)	#U
	Sprite.create(4, 0x91)	#R
	Sprite.create(5, 0x80)	#A
	Sprite.create(6, 0x89)	#J
	Sprite.create(7, 0x80)	#A
	Sprite.create(8, 0x8c)	#M
	
	Sprite.start(0x13)	#-> 背景をピンクにする
	x = 2
	f = 7
	y = 36
	Sprite.move(0, x, y)
	x = x + f
	Sprite.move(1, x, y)
	x = x + f
	Sprite.move(2, x, y)
	x = x + f
	Sprite.move(3, x, y)
	x = x + f
	Sprite.move(4, x, y)
	x = x + f
	Sprite.move(5, x, y)
	x = x + f + 4
	Sprite.move(6, x, y)
	x = x + f
	Sprite.move(7, x, y)
	x = x + f
	Sprite.move(8, x, y)

	delay(1000)
	
	Sprite.start(0xff)

	x = 0
	y = 0
	stmp = "ffffffffffffffff"
	PanCake.stamp1(x, y, 0, stmp)
	PanCake.stamp1(x, y+8, 0, stmp)
	x = x + f
	PanCake.stamp1(x, y, 1, stmp)
	PanCake.stamp1(x, y+8, 1, stmp)
	x = x + f
	PanCake.stamp1(x, y, 2, stmp)
	PanCake.stamp1(x, y+8, 2, stmp)
	x = x + f
	PanCake.stamp1(x, y, 3, stmp)
	PanCake.stamp1(x, y+8, 3, stmp)
	x = x + f
	PanCake.stamp1(x, y, 4, stmp)
	PanCake.stamp1(x, y+8, 4, stmp)
	x = x + f
	PanCake.stamp1(x, y, 5, stmp)
	PanCake.stamp1(x, y+8, 5, stmp)
	x = x + f
	PanCake.stamp1(x, y, 6, stmp)
	PanCake.stamp1(x, y+8, 6, stmp)
	x = x + f
	PanCake.stamp1(x, y, 7, stmp)
	PanCake.stamp1(x, y+8, 7, stmp)
	x = x + f
	PanCake.stamp1(x, y, 8, stmp)
	PanCake.stamp1(x, y+8, 8, stmp)
	x = x + f
	PanCake.stamp1(x, y, 9, stmp)
	PanCake.stamp1(x, y+8, 9, stmp)
	x = 0
	y = y + 16
	PanCake.stamp1(x, y,10, stmp)
	PanCake.stamp1(x, y+8,10, stmp)
	x = x + f
	PanCake.stamp1(x, y,11, stmp)
	PanCake.stamp1(x, y+8,11, stmp)
	x = x + f
	PanCake.stamp1(x, y,12, stmp)
	PanCake.stamp1(x, y+8,12, stmp)
	x = x + f
	PanCake.stamp1(x, y,13, stmp)
	PanCake.stamp1(x, y+8,13, stmp)
	x = x + f
	PanCake.stamp1(x, y,14, stmp)
	PanCake.stamp1(x, y+8,14, stmp)
	x = x + f
	PanCake.stamp1(x, y,15, stmp)
	PanCake.stamp1(x, y+8,15, stmp)
	

	
	#PanCake.line(0,0,79,45,8)
	#PanCake.line(79,0,0,45,8)



	#PanCake.circle(40,20,8,10)
	#delay(10)
	
	#PanCake.stamp(10,10,0,"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef")
	#delay(10)
	#PanCake.stamp1(20,10,2,"aa55aa55aa55aa55")
	#delay(10)

	#PanCake.sound1(0, 4, 0x00)
	#PanCake.sound1(1, 4, 0x04)
	#PanCake.sound1(2, 4, 0x07)
	#delay(2000)

	#PanCake.sound(4,0x00, 4,0x04, 4,0x07, 5,0x00)
	#delay(2000)

	#Music.score(1, 0, 0x82, "gee_fdd_cdefggg_geeefdddceggeee_dddddef_eeeeefg_geeefdddceggeee_")
	#Music.score(0, 0, 0x80, "ccggaag_ffeeddc_ccggaag_ffeeddc_ggffeed_ggffeed_ccggaag_ffeeddc_")
	#Music.play 1


	300.times do|i|
		delay(1000)
		fileloader()
	end

	10.times do|i|
		led(x)
		x = 1 - x
	
		@S.print(0,i.to_s + " Hello Wakayama.rb! Ver. ")
		@S.println(0, @Sy.version())
		
		@S.print(0,"mruby Ver. ")
		@S.println(0, @Sy.version(0))

		#ファイルローダーチェック
		fileloader()
		delay(500)
	end

	#プログラムの呼び出し
	#Sy.setrun("sample.mrb")
	