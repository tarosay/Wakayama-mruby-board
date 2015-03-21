//************************************************************************
//
// LLbRubyの呼び出し実行モジュールプログラム 2015.3.22 vARIDA
//
//************************************************************************
#include <rxduino.h>
#include <string.h>

volatile char	ProgVer[] = {"ARIDA-2.0 (2015/3/22)"};

//#include <mruby.h>
#include <mruby/irep.h>
#include <mruby/string.h>
#include <mruby/variable.h>

#include <eepfile.h>
#include <eeploader.h>

#include "../llbruby.h"
#include "sExec.h"
#include "sKernel.h"
#include "sSys.h"
#include "sSerial.h"
#include "sMem.h"
#include "sI2c.h"
#include "sServo.h"
#include "sRtc.h"


extern char RubyStartFileName[];
extern char RubyFilename[];
extern char ExeFilename[];

uint8_t RubyCode[RUBY_CODE_SIZE];	//静的にRubyコード領域を確保する

//**************************************************
//  スクリプト言語を実行します
//**************************************************
bool RubyRun( void )
{
bool notFinishFlag = true;

	//DEBUG_PRINT("mrb_open","before");
	mrb_state *mrb = mrb_open();
	//DEBUG_PRINT("mrb_open","after");
	
	if(mrb == NULL){
		Serial.println( "Can not Open mrb!!" );
		return false;
	}

	kernel_Init(mrb);	//カーネル関連メソッドの設定
	sys_Init(mrb);		//システム関連メソッドの設定
	serial_Init(mrb);	//シリアル通信関連メソッドの設定
	mem_Init(mrb);		//ファイル関連メソッドの設定
	i2c_Init(mrb);		//I2C関連メソッドの設定
	servo_Init(mrb);	//サーボ関連メソッドの設定
	rtc_Init(mrb);		//RTC関連メソッドの設定


	//DEBUG_PRINT("RubyFilename",RubyFilename);

	strcpy( ExeFilename, RubyFilename );		//実行するファイルをExeFilename[]に入れる。
	strcpy( RubyFilename, RubyStartFileName );	//とりあえず、RubyFilename[]をRubyStartFileName[]に初期化する。

	//DEBUG_PRINT("ExeFilename",ExeFilename);

	FILEEEP fpj;
	FILEEEP *fp = &fpj;
	if(EEP.fopen(fp, ExeFilename, EEP_READ) == -1){
		char az[50];
		sprintf( az,  "%s is not Open!!", ExeFilename );
		Serial.println( az );
		mrb_close(mrb);

		fileloader((const char*)ProgVer,"");
		return false;
	}

	//mrbファイルチェックを行う
	int mrbFlag = 0;
	char he[8];
	for( int i=0; i<8; i++ ){	he[i] = EEP.fread(fp);	}

	if( !(he[0]=='R' && he[1]=='I'
	&& he[2]=='T' && he[3]=='E'
	&& he[4]=='0' && he[5]=='0'
	&& he[6]=='0' && he[7]=='3') ){
		char az[50];
		sprintf( az,  "%s is not mrb file!!", ExeFilename );
		Serial.println( az );

		EEP.fclose(fp);
		mrb_close(mrb);
		return false;
	}

	//先頭にする
	EEP.fseek(fp, 0, EEP_SEEKTOP );

	//ファイルサイズを取得する
	unsigned long tsize = EEP.ffilesize(ExeFilename);

	if( tsize>RUBY_CODE_SIZE ){
		char az[50];
		sprintf( az,  "%s size is greater than %lu.", ExeFilename, RUBY_CODE_SIZE );
		Serial.println( az );
		mrb_close(mrb);
		return false;
	}

	RubyCode[0] = 0;
	unsigned long pos = 0;
	while( !EEP.fEof(fp) ){
		RubyCode[pos] = EEP.fread(fp);
		pos++;
	}
	EEP.fclose(fp);

	//mrubyを実行します
	mrb_load_irep( mrb, (const uint8_t *)RubyCode);

	if( mrb->exc ){
		//mrb_p(mrb, mrb_obj_value(mrb->exc));

		mrb_value obj = mrb_funcall(mrb, mrb_obj_value(mrb->exc), "inspect", 0);
		struct RString *str;
		char *s;
		int len;
		if (mrb_string_p(obj)) {
			//str = mrb_str_ptr(obj);
			//s = str->ptr;
			s = RSTRING_PTR(obj);

			//len = str->len;
			len = RSTRING_LEN(obj);

			for( int i=0; i<len; i++ ){
				if( *s==0x22 ){
					s++;
					break;
				}
				s++;
			}

			const char *e = "Sys#exit";	//Sys#exitだったら正常終了ということ。
			for( int i=0; i<8; i++ ){
				if( *(s+i) != *(e+i) ){
			
					notFinishFlag = false;

					//fwrite(str->ptr, len, 1, stdout);	//エラー内容を標準出力する
					fwrite(RSTRING_PTR(obj), len, 1, stdout);	//エラー内容を標準出力する
					break;
				}
			}

			//fwrite(str->ptr, len, 1, stdout);	//標準出力する
		}
	}

	mrb_close(mrb);

	return notFinishFlag;
}
