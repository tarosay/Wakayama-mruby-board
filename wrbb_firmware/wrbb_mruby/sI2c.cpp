/*
 * I2C通信関連
 *
 * Copyright (c) 2015 Minao Yamamoto
 *
 * This software is released under the MIT License.
 * 
 * http://opensource.org/licenses/mit-license.php
 */
#include <rxduino.h>
#include <wire.h>

#include <mruby.h>

#include "../llbruby.h"
#include "sKernel.h"

TwoWire Wire;

//**************************************************
// I2C通信を行うピンを設定します: I2c.sdascl
//  I2c.sdascl( sda, scl )
//	sda: データピン
//  scl: クロックピン
//**************************************************
mrb_value mrb_i2c_SdaScl(mrb_state *mrb, mrb_value self)
{
int sda, scl;

	mrb_get_args(mrb, "ii", &sda, &scl);

	//I2Cピンの設定
	Wire.assignSdaScl(wrb2sakura(sda), wrb2sakura(scl));
	digitalWrite(wrb2sakura(sda), LOW);

	Wire.begin();	//Wire初期化

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// アドレスにデータを書き込みます: I2c.write
//  I2c.write( deviceID, address, data )
//	deviceID: デバイスID
//  address: 書き込みアドレス
//  data: データ
//
//  戻り値は以下のとおり
//		0: 成功
//		1: 送信バッファ溢れ
//		2: スレーブアドレス送信時にNACKを受信
//		3: データ送信時にNACKを受信
//		4: その他のエラー
//**************************************************
mrb_value mrb_i2c_write(mrb_state *mrb, mrb_value self)
{
int deviceID, addr, dat;

	mrb_get_args(mrb, "iii", &deviceID, &addr, &dat);

	Wire.beginTransmission(deviceID);
	Wire.write(addr);
	Wire.write(dat);

    return mrb_fixnum_value(Wire.endTransmission());
}

//**************************************************
// アドレスからデータを読み込み: I2c.read
//  I2c.read( deviceID, addressL[, addressH] )
//	deviceID: デバイスID
//  addressL: 読み込み下位アドレス
//  addressH: 読み込み上位アドレス
//
//  戻り値は読み込んだ値
//**************************************************
mrb_value mrb_i2c_read(mrb_state *mrb, mrb_value self)
{
int deviceID, addrL, addrH;
int dat = 0;
byte datH;

	int n = mrb_get_args(mrb, "ii|i", &deviceID, &addrL, &addrH);

	Wire.beginTransmission(deviceID);
	Wire.write(addrL);
	Wire.endTransmission();

	Wire.requestFrom(deviceID, 1);
	dat = Wire.read();

	if( n>=3 ){
		Wire.beginTransmission(deviceID);
		Wire.write(addrH);
		Wire.endTransmission();

		Wire.requestFrom(deviceID, 1);
		datH = Wire.read();

		dat += (datH<<8);
	}

    return mrb_fixnum_value( dat );
}

//**************************************************
// I2Cデバイスに対して送信を開始するための準備をする: I2c.begin
//	I2c.begin( deviceID )
//	この関数は送信バッファを初期化するだけで、実際の動作は行わない。繰り返し呼ぶと、送信バッファが先頭に戻る。
//	deviceID: デバイスID 0～0x7Fまでの純粋なアドレス
//**************************************************
mrb_value mrb_i2c_beginTransmission(mrb_state *mrb, mrb_value self)
{
int deviceID;

	mrb_get_args(mrb, "i", &deviceID);

	Wire.beginTransmission(deviceID);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 送信バッファの末尾に数値を追加する: I2c.lwrite
//	I2c.lwrite( data )
//	data: セットする値
//
// 戻り値は、送信したバイト数(バッファに溜めたバイト数)を返す。
//	送信バッファ(260バイト)に空き容量が無ければ失敗して0を返す
//**************************************************
mrb_value mrb_i2c_lwrite(mrb_state *mrb, mrb_value self)
{
int dat;

	mrb_get_args(mrb, "i", &dat);

	return mrb_fixnum_value( Wire.write(dat) );
}

//**************************************************
// デバイスに対してI2Cの送信シーケンスを発行する: I2c.end
//	I2c.end()
//	I2Cの送信はこの関数を実行して初めて実際に行われる。
//
// 戻り値は以下のとおり
//	0: 成功
//	1: 送信バッファ溢れ
//	2: スレーブアドレス送信時にNACKを受信
//	3: データ送信時にNACKを受信
//	4: その他のエラー
//**************************************************
mrb_value mrb_i2c_endTransmission(mrb_state *mrb, mrb_value self)
{
    return mrb_fixnum_value(Wire.endTransmission());
}

//**************************************************
// デバイスに対して受信シーケンスを発行しデータを読み出す: I2c.request
//	I2c.request( address, count )
//	address: 読み込み開始アドレス
//	count: 読み出す数
//
//  戻り値は、実際に受信したバイト数。
//**************************************************
mrb_value mrb_i2c_requestFrom(mrb_state *mrb, mrb_value self)
{
int addr, cnt;

	mrb_get_args(mrb, "ii", &addr, &cnt);

    return mrb_fixnum_value( Wire.requestFrom(addr, cnt) );
}

//**************************************************
// デバイスに対して受信シーケンスを発行しデータを読み出す: I2c.lread
//	I2c.lread()
//
//  戻り値は読み込んだ値
//**************************************************
mrb_value mrb_i2c_lread(mrb_state *mrb, mrb_value self)
{
    return mrb_fixnum_value( Wire.read() );
}

//**************************************************
// 周波数を変更する: I2c.freq
//  I2c.freq( Hz )
//  Hz: クロックの周波数をHz単位で指定する。
//      有効な値は1～200000程度。基本的にソフトでやっているので400kHzは出ない。
//**************************************************
mrb_value mrb_i2c_freq(mrb_state *mrb, mrb_value self)
{
int fq;

	mrb_get_args(mrb, "i", &fq);

	Wire.setFrequency( fq );

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// ライブラリを定義します
//**************************************************
void i2c_Init(mrb_state *mrb)
{
	struct RClass *i2cModule = mrb_define_module(mrb, "I2c");

	mrb_define_module_function(mrb, i2cModule, "sdascl", mrb_i2c_SdaScl, MRB_ARGS_REQ(2));
	mrb_define_module_function(mrb, i2cModule, "write", mrb_i2c_write, MRB_ARGS_REQ(3));
	mrb_define_module_function(mrb, i2cModule, "read", mrb_i2c_read, MRB_ARGS_REQ(2)|MRB_ARGS_OPT(1));
	
	mrb_define_module_function(mrb, i2cModule, "begin", mrb_i2c_beginTransmission, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, i2cModule, "lwrite", mrb_i2c_lwrite, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, i2cModule, "end", mrb_i2c_endTransmission, MRB_ARGS_NONE());
	mrb_define_module_function(mrb, i2cModule, "request", mrb_i2c_requestFrom, MRB_ARGS_REQ(2));
	mrb_define_module_function(mrb, i2cModule, "lread", mrb_i2c_lread, MRB_ARGS_NONE());
	mrb_define_module_function(mrb, i2cModule, "freq", mrb_i2c_freq, MRB_ARGS_REQ(1));
}
