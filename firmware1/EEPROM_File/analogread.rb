# coding: utf-8
Bt.println( "LLBruby v" + Sys.version )
Bt.println( "mruby " + Sys.version("mruby") )
#Read AD
while(true)do
	if(digitalRead(51)==1)then
		digitalWrite(100,1)
		Bt.analog(7, 0x80)
		digitalWrite(100,0)
	end
	if( Bt.available()>0)then
		Sys.fileload()
	end
	delay(500)
end	
