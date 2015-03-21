TARGET = wrbb
#CCPATH = /cygdrive/c/cygwin/usr/local/tkdn-20110720/rx-elf/bin/
AS  = $(CCPATH)rx-elf-as 
CC  = $(CCPATH)rx-elf-gcc -fsigned-char -Wall -g -I./include/tkdnhal -I./include/lib/ -I./gr_eepfile -I./gr_mruby -I./gr_mruby/include 
CPP = $(CCPATH)rx-elf-gcc -fsigned-char -Wall -g -I./include/tkdnhal -I./include/rxduino -I./include/lib/ -I./gr_eepfile -I./gr_mruby -I./gr_mruby/include 
LNK = $(CCPATH)rx-elf-ld
CNV = $(CCPATH)rx-elf-objcopy --srec-forceS3 --srec-len 32 -O srec
CNVBIN = $(CCPATH)rx-elf-objcopy -O binary
DMP = $(CCPATH)rx-elf-objdump
OBJS =	common/intvect.o common/lowlevel.o \
		./gr_eepfile/eepfile.o ./gr_eepfile/eeploader.o \
		./gr_mruby/sExec.o ./gr_mruby/sKernel.o ./gr_mruby/sSys.o ./gr_mruby/sSerial.o \
		./gr_mruby/sMem.o ./gr_mruby/sI2c.o ./gr_mruby/sServo.o ./gr_mruby/sRtc.o \
		./gr_mruby/libmruby.a \
		$(TARGET).o 

RXDUINO_STANDARD_LIBS = -lethernet -ltkdnip -lspi -lservo -lliquidcrystal -lsdmmc -leeprom -lstepper -lwire
LFLAGS = -Llib/gcc -Llib $(RXDUINO_STANDARD_LIBS) -lrxduino -lstdc++ -lsupc++ -lc -lsim -lgcc -lm -ltkdnhal -nostartfiles
MAKEFILE = makefile
ROMSCRIPT=common/rx63n_rom_standalone.ld
STARTUP=lib/start.o
GSTARTUP=
make = make --no-print-directory 

all:	rom

rom:	$(OBJS) $(STARTUP) $(MAKEFILE) $(ROMSCRIPT)
	$(LNK) -Map $(TARGET).map $(STARTUP) $(OBJS) -T $(ROMSCRIPT) $(LFLAGS) -o $(TARGET).elf 
	$(CNV) $(TARGET).elf  $(TARGET).mot

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
	rm -f gr_eepfile/*.o
	rm -f gr_mruby/*.o
	rm -f *.bin
