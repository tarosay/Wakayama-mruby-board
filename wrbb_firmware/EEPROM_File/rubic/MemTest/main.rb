#!mruby
MemFile.open(0, 'sample.txt', 2)
  MemFile.write(0, 'Hello mruby World', 17)
  data = 0x30.chr + 0x31.chr + 0.chr + 0x32.chr + 0x33.chr
  MemFile.write(0, data, 5 )
MemFile.close(0)

MemFile.copy('sample.txt', 'memfile.txt',1)

Serial.begin(0, 115200)		#USBシリアル通信の初期化

MemFile.open(0, 'memfile.txt')
while(true)do
  c = MemFile.read(0)
  if(c < 0)then
    break
  end
  Serial.write(0, c.chr, 1)
end  
MemFile.close(0)
System.exit()