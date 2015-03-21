# GetMRB 
# https://dl.dropboxusercontent.com/u/14702102/mrb/lchika.mrb
# http://dl.dropboxusercontent.com/u/14702102/mrb/lchika.mrb	

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

	Net.getmrb("dl.dropboxusercontent.com","/u/14702102/mrb/lchika.mrb",80,0)
 