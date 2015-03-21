# NETGet 
	
	  #3G Power ON
	5.times do
		if(Net.begin(4800)==0)then
			sw = 1
			break
		end
	end

	
	Net.getmrb("dl.dropboxusercontent.com","/u/14702102/mrb/lchika.mrb",448,1)
	
