/*
 * シリアル通信関連
 *
 * Copyright (c) 2015 Minao Yamamoto
 *
 * This software is released under the MIT License.
 * 
 * http://opensource.org/licenses/mit-license.php
 */
#include <rxduino.h>

#include <mruby.h>
#include <mruby/string.h>

#include "../llbruby.h"

#define SERIAL_MAX	5

char EnableNum[SERIAL_MAX];
CSerial *serial[SERIAL_MAX];


//**************************************************
// シリアル通信を初期化します: Serial.begin
//  Serial.begin(num, bps)
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8, 4:TX/RX)
//  bps: ボーレート 
//**************************************************
mrb_value mrb_serial_begin(mrb_state *mrb, mrb_value self)
{
int num, bps;

	mrb_get_args(mrb, "ii", &num, &bps);

	if (num < 0 || num >= SERIAL_MAX){
		return mrb_nil_value();			//戻り値は無しですよ。
	}

	if(num == 0){
		serial[num] = &Serial;
	}
	else{
		if (serial[num] != 0){
			serial[num]->end();
			delay(50);
			delete serial[num];
		}
	
		serial[num] = new CSerial();
	}

	//シリアル通信の初期化
	SCI_PORT sci = SCI_USB0;
	switch(num){
	case 1:
		sci = SCI_SCI0P2x;
		break;
	case 2:
		sci = SCI_SCI2B;
		break;
	case 3:
		sci = SCI_SCI6B;
		break;
	case 4:
		sci = SCI_SCI2A;
		break;
	default:
		sci = SCI_USB0;
		break;
	}

	if(sci != SCI_USB0){
		serial[num]->begin(bps, sci);
		sci_convert_crlf_ex(serial[num]->get_handle(), CRLF_NONE, CRLF_NONE);		//バイナリを通せるようにする
	}

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// シリアル通信のデフォルト出力ポートを設定します: Serial.setDefault
//  Serial.setDefault(num)
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8)
//**************************************************
mrb_value mrb_serial_setdefault(mrb_state *mrb, mrb_value self)
{
int num;

	mrb_get_args(mrb, "i", &num);

	if (num < 0 || num >= SERIAL_MAX){
		return mrb_nil_value();
	}

	serial[num]->setDefault();
	
	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// シリアルに出力します: Serial.print|Serial.println
//**************************************************
void mrb_serial_msprint(int num, mrb_value text)
{

	if(num < 10)
	{
		serial[num]->print( RSTRING_PTR(text) );
	}
	else if(num < 20)
	{
		serial[num - 10]->println( RSTRING_PTR(text) );
	}
	else{
		serial[num - 20]->println();
	}
}

mrb_value msprintMode(mrb_state *mrb, mrb_value self, int mode)
{
int num;
mrb_value text;

	int n = mrb_get_args(mrb, "i|S", &num, &text);

	if (num < 0 || num >= SERIAL_MAX){
		return mrb_nil_value();
	}

	if(mode == 0){
		if(n >= 2){
			mrb_serial_msprint(num,  text);
		}
	}
	else{
		if(n >= 2){
			mrb_serial_msprint(num + 10,  text);
		}
		else{
			mrb_serial_msprint(num + 20,  text);
		}
	}
	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// シリアルに出力します: Serial.print
//  Serial.print(num[,str])
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8)
//  str: 文字列
//    省略時は何も出力しません
//**************************************************
mrb_value mrb_serial_print(mrb_state *mrb, mrb_value self)
{
	return msprintMode(mrb, self, 0);
}

//**************************************************
// シリアルに\r\n付きで出力します: Serial.println
//  Serial.println(num[,str])
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8)
//  str: 文字列
//    省略時は改行のみ
//**************************************************
mrb_value mrb_serial_println(mrb_state *mrb, mrb_value self)
{
	return msprintMode(mrb, self, 1);
}

//**************************************************
// シリアルから1バイト取得します: Serial.read
//  Serial.read(num)
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8)
// 戻り値
//	0x00～0xFFの値、データが無いときは-1が返ります
//**************************************************
mrb_value mrb_serial_read(mrb_state *mrb, mrb_value self)
{
int num;

	mrb_get_args(mrb, "i", &num);

	if (num >= 0 && num < SERIAL_MAX){
		if(serial[num]->available()){
			return mrb_fixnum_value( serial[num]->read() );
		}
	}
	return mrb_fixnum_value( -1 );
}

//**************************************************
// シリアルにデータを出力します: Serial.write
//  Serial.write(num, buf, len)
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8)
//	buf: 出力データ
//	len: 出力データサイズ
// 戻り値
//	出力したバイト数
//**************************************************
mrb_value mrb_serial_write(mrb_state *mrb, mrb_value self)
{
int		num;
int		len;
mrb_value value;
char	*str;

	mrb_get_args(mrb, "iSi", &num, &value, &len);

	str = RSTRING_PTR(value);
	
	if (num < 0 || num >= SERIAL_MAX){
		return mrb_fixnum_value( 0 );
	}

	return mrb_fixnum_value( serial[num]->write( (const unsigned char *)str, len));
}

//**************************************************
// シリアルデータがあるかどうか調べます: Serial.available
//  Serial.available(num)
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8)
//  戻り値 シリアルバッファにあるデータのバイト数。0の場合はデータなし
//**************************************************
mrb_value mrb_serial_available(mrb_state *mrb, mrb_value self)
{
int		num;
	
	mrb_get_args(mrb, "i", &num);

	if (num < 0 || num >= SERIAL_MAX){
		return mrb_fixnum_value( 0 );
	}
	return mrb_fixnum_value( serial[num]->available() );
}

//**************************************************
// シリアルポートを閉じます: Serial.end
//  Serial.end(num)
//  num: 通信番号(0:USB, 1:TX0/RX1, 2:TX5/RX6, 3:TX7/RX8, 4:TX/RX)
//**************************************************
mrb_value mrb_serial_end(mrb_state *mrb, mrb_value self)
{
int		num;
int		ret = 0;
	
	mrb_get_args(mrb, "i", &num);

	if (num < 0 || num >= SERIAL_MAX){
		return mrb_nil_value();			//戻り値は無しですよ。
	}

	if(num != 0){	//USBは閉じない

		if (serial[num] != 0){
			serial[num]->end();
			delay(50);
			delete serial[num];
		}
	}
	serial[num] = 0;

	return mrb_fixnum_value( ret );
}

//**************************************************
// シリアルにデータを出力します: Serial.write
//  Serial.write( buf )
//	buf: 出力データ
//**************************************************
/*
mrb_value mrb_system_write(mrb_state *mrb, mrb_value self)
{
int dat;

	mrb_get_args(mrb, "i", &dat);

	int ret = Serial.write( (unsigned char)dat );
	
	return mrb_fixnum_value( ret );
}
*/

//**************************************************
// ライブラリを定義します
//**************************************************
void serial_Init(mrb_state *mrb)
{
	for (int i = 0; i < SERIAL_MAX; i++){
		serial[i] = 0;
	}

	struct RClass *serialModule = mrb_define_module(mrb, "Serial");

	mrb_define_module_function(mrb, serialModule, "begin", mrb_serial_begin, MRB_ARGS_REQ(2));
	mrb_define_module_function(mrb, serialModule, "setDefault", mrb_serial_setdefault, MRB_ARGS_REQ(2));
	mrb_define_module_function(mrb, serialModule, "print", mrb_serial_print, MRB_ARGS_REQ(1)|MRB_ARGS_OPT(1));
	mrb_define_module_function(mrb, serialModule, "println", mrb_serial_println, MRB_ARGS_REQ(1)|MRB_ARGS_OPT(1));

	mrb_define_module_function(mrb, serialModule, "read", mrb_serial_read, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, serialModule, "write", mrb_serial_write, MRB_ARGS_REQ(3));
	mrb_define_module_function(mrb, serialModule, "available", mrb_serial_available, MRB_ARGS_REQ(1));

	mrb_define_module_function(mrb, serialModule, "end", mrb_serial_end, MRB_ARGS_REQ(1));
}
