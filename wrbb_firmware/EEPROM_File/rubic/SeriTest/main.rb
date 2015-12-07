#!mruby
Serial.begin(0, 115200)		#USBシリアル通信の初期化

Sw = 0

while(Serial.available(0) > 0)do	#何か受信があった
  Serial.read(0).chr		#1文字取得
end

50.times do
  while(Serial.available(0) > 0)do	#何か受信があった
    c = Serial.read(0).chr		#1文字取得
    Serial.print(0, c)			#エコーバック
    System.fileload()
end
	
  #LEDを点滅させます
  led(Sw)
  Sw = 1 - Sw
	
  delay(500)
end