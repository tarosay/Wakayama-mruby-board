@S = Serial
@Sy = System
@S.begin(0, 115200)		#USBƒVƒŠƒAƒ‹’ÊM‚Ì‰Šú‰»

delay(1500)

PanCake.serial 1 

PanCake.video 0
PanCake.reset

PanCake.clear 0
PanCake.video 1

p1 = "ffffffffffffffff"
p2 = "ffffff0000000000"

4.times do|y|
  4.times do|x|
    c = x + 4 * y
	3.times do|i|
      PanCake.stamp1 x*20 + i*8, y*11, c, p1 
      PanCake.stamp1 x*20 + i*8, y*11 + 8, c, p2 
	end
  end
end

300.times do
  if(@S.available(0)>0)then
    @Sy.fileload()
  end
  delay(1000)
end

@Sy.setrun("sakura.mrb")
@Sy.exit