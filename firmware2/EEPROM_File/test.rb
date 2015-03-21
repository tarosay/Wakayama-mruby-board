# TEST 
sw = 0
	5.times do
		if(Net.begin(4800)==0)then
			sw = 1
			break
		end
	end

	if(sw==0)then
		Sys.exit()
	end
	
	sw = 0
	5.times do
		a = Net.date()
	  Serial.println(0, a)
		a = Net.time()
	  Serial.println(0, a)
	  a = Net.lat()
		if( a=="00" )then
			break
		end
	  Serial.println(0, a)
	  a = Net.lng()
	  Serial.println(0, a)
		led(sw)
		sw = 1 - sw
		delay(100)
	end
	
	Net.getmrb("dl.dropboxusercontent.com","/u/14702102/mrb/lchika.mrb",448,1)
	
