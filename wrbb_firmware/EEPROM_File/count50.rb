# coding: utf-8
# Sample
@Mem = MemFile
@Srv = Servo
@S = Serial
@Sy = System

# ���낢��ȏ�����
def init()
	@S.begin(0, 115200)		#USB�V���A���ʐM�̏�����
end

# �t�@�C�����[�_�[�N��
def fileloader()
	#USB����̃L�[���͂���
	if(@S.available(0)>0)then
		@Sy.fileload()
	end
end

init()

50.times do|i|
	@S.print(0, i.to_s)
	delay(250)
	led(i % 2)
end



