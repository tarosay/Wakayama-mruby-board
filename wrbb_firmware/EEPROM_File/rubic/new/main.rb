#!mruby
Serial.begin(0, 115200)
Serial.println(0, "Hello WRB!!")

data = 0x30.chr + 0x31.chr + 0.chr + 0x32.chr + 0x33.chr + 0x0d.chr + 0x0a.chr
Serial.write(0, data, 7 )		#1番ポートに7バイトのデータを出力

System.exit()
