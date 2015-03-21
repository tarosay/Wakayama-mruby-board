//**************************************************
// EEPROM FIle Loader
//**************************************************
#include <rxduino.h>
#include <eepfile.h>

#include <mruby.h>
#include <mruby/string.h>
#include <mruby/variable.h>
#include <mruby/version.h>

#include <eeploader.h>
#include "../llbruby.h"

extern char RubyFilename[];
extern uint8_t RubyCode[];
char *Arry = (char*)RubyCode;
bool StopFlg = false;		//強制終了フラグ

//**************************************************
// ライン入力
//**************************************************
void lineinput(char *arry)
{
	char az[10];
	int k = 0;
	while(k >= 0){
		k = Serial.read();
	}

	int len = 0;
	while(true){
		k = 0;
		while(k <= 0){
			k = Serial.read();
			delay(10);
		}
		if (k == 13 || k == 10){	break;	}
		if (k == 8){
			len--;
			if (len < 0){	len = 0;	}
		}
		else{
			arry[len] = k;
			len++;
			if (len > 31){	break;	}
		}
		Serial.print((char)k);
	}
	arry[len] = 0;
}

//**************************************************
// ファイルを保存します
// 60sec待って、データが何も送られてこないときには、
// ファイル保存を終了します
//**************************************************
void writefile(char *fname, int size)
{
	FILEEEP fpj;
	FILEEEP *fp = &fpj;
	unsigned long tm;
	int k = 0;

	if(size<=0 || size>=RUBY_CODE_SIZE){
		return;
	}

	Serial.println();

	//シリアルバッファ消去
	while(k >= 0){	k = Serial.read();	}

	Serial.print("Waiting ");
	tm = millis() + 60000;
	int sa = 0;
	int writeFlg = 0;
	while(tm > millis()){
		if (Serial.available() > 0){
			writeFlg = 1;
			break;
		}
		if(sa != (tm - millis()) / 1000){
			sa = (tm - millis()) / 1000;
			Serial.print(" ");
			Serial.print(sa, 10);
		}
	}

	Serial.println();
	if(writeFlg == 1){
		int cnt = 0;

		tm = millis() + 2000;
		while(cnt<size){
			if (Serial.available() > 0){
				k = Serial.read();
				Arry[cnt] = k;
				cnt++;
				tm = millis() + 2000;
			}
			if(tm < millis()){	break;	}
		}

		if(tm < millis()){
			Serial.println("..Read Error!");
			return;
		}

		Serial.print(fname);
		Serial.print(" Saving");

		if(EEP.fopen(fp, fname, EEP_WRITE) == -1){
			return;
		}

		for(int i=0; i<size; i++){
			if(EEP.fwrite(fp, Arry[i]) == -1){
				break;
			}
			if((i%256) == 0){
				Serial.print(".");
			}
		}
		EEP.fclose(fp);
		Serial.println(".");
	}

	StopFlg = true;
}

//**************************************************
// ファイルローダー
// 戻り値 0:何もしない, 1:強制終了する
//**************************************************
int fileloader(const char* str0, const char* str1)
{
	char fname[32];
	int size = 0;
	int led = digitalRead(RB_LED);

	StopFlg = false;

	while(true){
		//LEDを点灯する
		digitalWrite(RB_LED, HIGH);

		//コマンド待ち
		Serial.println();
		Serial.print("WAKAYAMA.RB Board V.");
		Serial.print(str0);
		if(str1[0] != 0){
			Serial.print(", mruby ");
			Serial.print(str1);
		}
		Serial.println(" (help->H [ENTER])");
		Serial.print(">");
		lineinput(Arry);

		Serial.println();

		if (Arry[0] == 'Z'){
			EEP.format();
		}
		else if (Arry[0] == 'D'){
			if(strlen(Arry) > 2){

				//スペースを0に変えて、ポインタを取得
				char *fs;
				int len = strlen(Arry);
				for(int i=0; i<len; i++){
					if(Arry[i] == ' '){
						fs = &Arry[i+1];
						break;
					}
				}
				strcpy(fname, fs);
				EEP.fdelete((const char*)fname);
			}
		}
		else if (Arry[0] == 'R'){
			if(strlen(Arry) > 2){

				//スペースを0に変えて、ポインタを取得
				char *fs;
				int len = strlen(Arry);
				for(int i=0; i<len; i++){
					if(Arry[i] == ' '){
						fs = &Arry[i+1];
						break;
					}
				}
				strcpy(fname, fs);
				strcpy( (char*)RubyFilename, fname );

				//強制終了フラグを立てる
				StopFlg = true;
			}
		}
		else if(Arry[0] == 'W'){
			if(strlen(Arry) > 3){
				//スペースを0に変えて、ポインタを取得
				char *fs[4];
				int j = 0;
				int len = strlen(Arry);
				for(int i=0; i<len; i++){
					if(Arry[i] == ' '){
						Arry[i] = 0;
						fs[j] = &Arry[i+1];
						j++;
						if(j>2){	break;	}
					}
				}
				strcpy(fname, fs[0]);
				size = atoi(fs[1]);
				writefile(fname, size);
			}
		}
		else if(Arry[0] == 'E'){
			//ファームウェア書き込み待ちにする
			system_reboot( REBOOT_USERAPP );	//リセット後にユーザアプリを起動する
			//system_reboot( REBOOT_FIRMWARE );	//リセット後にファームウェアを起動する
		}
		else if (Arry[0] == 'L'){
			Serial.println();
			for(int i=0; i<64; i++){
					
				size = EEP.fdir( i, fname );
					
				if(fname[0] != 0){
					Serial.print(" ");
					Serial.print(fname);
					Serial.print(" ");
					Serial.print(size);
					Serial.println(" byte");
				}
			}
		}
		else if(Arry[0] == 'A'){
			EEP.viewFat();
		}
		else if(Arry[0] == 'S'){
			if(strlen(Arry) > 2){
				//スペースを0に変えて、ポインタを取得
				char *fs;
				int len = strlen(Arry);
				for(int i=0; i<len; i++){
					if(Arry[i] == ' '){
						fs = &Arry[i+1];
						break;
					}
				}
				EEP.viewSector( atoi(fs) );
			}
		}
		else if(Arry[0] == 'Q'){
			break;
		}
		else{
			Serial.println();
			Serial.println("EEPROM FileWriter Ver. 1.16");
			Serial.println(" Command List");
			Serial.println(" L:List Filename..........>L [ENTER]");
			Serial.println(" W:Write File.............>W Filename Size [ENTER]");
			Serial.println(" D:Delete File............>D Filename [ENTER]");
			Serial.println(" Z:Delete All Files.......>Z [ENTER]");
			Serial.println(" A:List FAT...............>A [ENTER]");
			Serial.println(" R:Set Run File...........>R Filename [ENTER]");
			Serial.println(" S:List Sector............>S Number [ENTER]");
			Serial.println(" Q:Quit...................>Q [ENTER]");
			Serial.println(" E:System Reset...........>E [ENTER]");
		}
	}

	digitalWrite(RB_LED, led);

	if(StopFlg == true){
		return 1;
	}
	return 0;
}
