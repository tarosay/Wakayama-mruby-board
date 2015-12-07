#!mruby
Serial.begin(0, 115200)		#USBシリアル通信の初期化

#Rtc.begin

#Rtc.setDateTime(2015,12,5,17,0,0)

15.times do|i|
  led(i % 2)
  year,mon,da,ho,min,sec = Rtc.getDateTime()
  Serial.println(0,year.to_s + "/" + mon.to_s + "/" + da.to_s + " " + ho.to_s + ":" + min.to_s + ":" + sec.to_s)
  delay(500)
end
