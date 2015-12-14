TARGET = wrbb
#CCPATH = /cygdrive/c/cygwin/usr/local/tkdn-20110720/rx-elf/bin/
AS  = $(CCPATH)rx-elf-as 
CC  = $(CCPATH)rx-elf-gcc -fsigned-char -Wall -g -I./include/tkdnhal -I./include/lib/ -I./wrbb_eepfile -I./wrbb_mruby -I./wrbb_mruby/include 
CPP = $(CCPATH)rx-elf-gcc -fsigned-char -Wall -g -I./include/tkdnhal -I./include/rxduino -I./include/lib/ -I./wrbb_eepfile -I./wrbb_mruby -I./wrbb_mruby/include 
LNK = $(CCPATH)rx-elf-ld
CNV = $(CCPATH)rx-elf-objcopy --srec-forceS3 --srec-len 32 -O srec
CNVBIN = $(CCPATH)rx-elf-objcopy -O binary
DMP = $(CCPATH)rx-elf-objdump
#PANCAKE = ./wrbb_mruby/sPanCake.o 
SDCARD = ./wrbb_mruby/sSdCard.o 
RTC = ./wrbb_mruby/sRtc.o 
#WIFI = ./wrbb_mruby/sWiFi.o
OBJS =	common/intvect.o common/lowlevel.o \
		./wrbb_eepfile/eepfile.o ./wrbb_eepfile/eeploader.o \
		./wrbb_mruby/sExec.o ./wrbb_mruby/sKernel.o ./wrbb_mruby/sSys.o ./wrbb_mruby/sSerial.o \
		./wrbb_mruby/sMem.o ./wrbb_mruby/sI2c.o ./wrbb_mruby/sServo.o \
		$(RTC) $(PANCAKE) $(SDCARD) $(WIFI) \
		./wrbb_mruby/libmruby.a \
		$(TARGET).o 

RXDUINO_STANDARD_LIBS = -lethernet -ltkdnip -lspi -lservo -lliquidcrystal -lsdmmc -leeprom -lstepper -lwire
LFLAGS = -Llib/gcc -Llib $(RXDUINO_STANDARD_LIBS) -lrxduino -lstdc++ -lsupc++ -lc -lsim -lgcc -lm -ltkdnhal -nostartfiles
MAKEFILE = makefile
ROMSCRIPT=common/rx63n_rom_standalone.ld
GADGETSCRIPT=common/gr_sakura_test_Release_auto.gsi
STARTUP=lib/start.o
GSTARTUP=
make = make --no-print-directory 

all:	rom

rom:	$(OBJS) $(STARTUP) $(MAKEFILE) $(ROMSCRIPT)
	$(LNK) -Map $(TARGET).map $(STARTUP) $(OBJS) -T $(ROMSCRIPT) $(LFLAGS) -o $(TARGET).elf 
	$(CNV) $(TARGET).elf  $(TARGET).mot

gadget:	$(OBJS) $(GSTARTUP) $(MAKEFILE) $(ROMSCRIPT)
	$(LNK) -Map $(TARGET).map $(GSTARTUP) $(OBJS) -T $(GADGETSCRIPT) $(LFLAGS) -o $(TARGET).elf 
	$(CNV) $(TARGET).elf  $(TARGET).mot
	$(CNVBIN) $(TARGET).elf  $(TARGET).bin

.c.o:
	$(CC) -Wall -O2 -c $< -o $@

.cpp.o:
	$(CPP) -Wall -O2 -c $< -o $@

clean: 
	rm -f *.o
	rm -f $(TARGET).out
	rm -f $(TARGET).elf
	rm -f $(TARGET).lst
	rm -f $(TARGET).map
	rm -f $(TARGET).mot
	rm -f wrbb_eepfile/*.o
	rm -f wrbb_mruby/*.o
	rm -f *.bin
