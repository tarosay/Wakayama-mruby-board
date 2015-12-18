/*
 * カーネル関連
 *
 * Copyright (c) 2015 Minao Yamamoto
 *
 * This software is released under the MIT License.
 * 
 * http://opensource.org/licenses/mit-license.php
 */
#include <rxduino.h>
//#include <string.h>
//#include <time.h>
//#include <sys/time.h>

#include <mruby.h>
//#include "mruby/string.h"
//#include "mruby/variable.h"
//#include "mruby/array.h"

#include "../llbruby.h"

//**************************************************
// WRBB - SAKURAピン番コンバート
//**************************************************
int wrb2sakura(int pin)
{
int ret = 0;

	switch(pin){
	case 0:
		ret = RB_PIN0;
		break;
	case 1:
		ret = RB_PIN1;
		break;
	case 2:
		ret = RB_PIN2;
		break;
	case 3:
		ret = RB_PIN3;
		break;
	case 4:
		ret = RB_PIN4;
		break;
	case 5:
		ret = RB_PIN5;
		break;
	case 6:
		ret = RB_PIN6;
		break;
	case 7:
		ret = RB_PIN7;
		break;
	case 8:
		ret = RB_PIN8;
		break;
	case 9:
		ret = RB_PIN9;
		break;
	case 10:
		ret = RB_PIN10;
		break;
	case 11:
		ret = RB_PIN11;
		break;
	case 12:
		ret = RB_PIN12;
		break;
	case 13:
		ret = RB_PIN13;
		break;
	case 14:
		ret = RB_PIN14;
		break;
	case 15:
		ret = RB_PIN15;
		break;
	case 16:
		ret = RB_PIN16;
		break;
	case 17:
		ret = RB_PIN17;
		break;
	case 18:
		ret = RB_PIN18;
		break;
	case 19:
		ret = RB_PIN19;
		break;

	case 20:
		ret = RB_PIN20;
		break;
	case 21:
		ret = RB_PIN21;
		break;
	case 22:
		ret = RB_PIN22;
		break;
	case 23:
		ret = RB_PIN23;
		break;
	case 24:
		ret = RB_PIN24;
		break;
	case 25:
		ret = RB_PIN25;
		break;
	}

return ret;
}

//**************************************************
// デジタルライト
//	digitalWrite(pin, value)
//	pin
//		ピンの番号
//	value
//		0: LOW
//		1: HIGH
//**************************************************
mrb_value mrb_kernel_digitalWrite(mrb_state *mrb, mrb_value self)
{
int pin, value;

	mrb_get_args(mrb, "ii", &pin, &value);

	digitalWrite( wrb2sakura(pin), value );

	return mrb_nil_value();	//戻り値は無しですよ。
}

//**************************************************
// PINのモード設定
//	pinMode(pin, mode)
//  pin
//		ピンの番号
//	mode
//		0: INPUTモード
//		1: OUTPUTモード
//**************************************************
mrb_value mrb_kernel_pinMode(mrb_state *mrb, mrb_value self)
{
int pin, value;

	mrb_get_args(mrb, "ii", &pin, &value);

	pinMode( wrb2sakura(pin), value );

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// ディレイ 強制GCを行っています
//	delay(value)
//	value
//		時間(ms)
//**************************************************
mrb_value mrb_kernel_delay(mrb_state *mrb, mrb_value self)
{
int value;

	mrb_get_args(mrb, "i", &value);

	//試しに強制gcを入れて見る
	mrb_full_gc(mrb);

	if(value >0 ){
		delay( value );
	}

	return mrb_nil_value();			//戻り値は無しですよ。
}


//**************************************************
// ミリ秒を取得します: millis
//	millis()
// 戻り値
//	起動してからのミリ秒数
//**************************************************
mrb_value mrb_kernel_millis(mrb_state *mrb, mrb_value self)
{	
	return mrb_fixnum_value( (mrb_int)millis() );
}

//**************************************************
// マイクロ秒を取得します: micros
//	micros()
// 戻り値
//	起動してからのマイクロ秒数
//**************************************************
mrb_value mrb_kernel_micros(mrb_state *mrb, mrb_value self)
{
	return mrb_fixnum_value( (mrb_int)micros() );
}

//**************************************************
// デジタルリード: digitalRead
//	digitalRead(pin)
//	pin: ピンの番号
//	
//		0:LOW
//		1:HIGH
//**************************************************
mrb_value mrb_kernel_digitalRead(mrb_state *mrb, mrb_value self)
{
int pin, value;

	mrb_get_args(mrb, "i", &pin);

	value = digitalRead(wrb2sakura(pin));

	return mrb_fixnum_value( value );
}

//**************************************************
// アナログリード: analogRead
//	analogRead(pin)
//	pin: アナログの番号
//	
//		10ビットの値(0～1023)
//**************************************************
mrb_value mrb_kernel_analogRead(mrb_state *mrb, mrb_value self)
{
int anapin, value;

	mrb_get_args(mrb, "i", &anapin);

	value = analogRead( anapin );

	return mrb_fixnum_value( value );
}

//**************************************************
// PWM出力: pwm
//	pwm(pin, value)
//	pin: ピンの番号
//  value:	出力PWM比率(0～255)
//**************************************************
mrb_value mrb_kernel_pwm(mrb_state *mrb, mrb_value self)
{
int pin, value;

	mrb_get_args(mrb, "ii", &pin, &value);

	if( value>=0 && value<256 ){
		analogWrite( wrb2sakura(pin), value );
	}
	else{
		analogWrite( wrb2sakura(pin), 0 );
	}

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// PWM周波数設定: pwmHz
//	pwmHz(value)
//  value:	周波数(12～184999)Hz
//**************************************************
mrb_value mrb_kernel_pwmHz(mrb_state *mrb, mrb_value self)
{
int value;

	mrb_get_args(mrb, "i", &value);

	if( value>=12 && value<18500 ){
		analogWriteFrequency(value);
	}

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// アナログDAC出力: analogDac
//	analogDac(value)
//  value:	10bit精度(0～4095)
//**************************************************
mrb_value mrb_kernel_analogDac(mrb_state *mrb, mrb_value self)
{
int value;

	mrb_get_args(mrb, "i", &value);

	if( value>=0 && value<4096 ){
		analogWriteDAC( 1, value );
	}

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// LEDオンオフ: led
//	led(sw)
//**************************************************
mrb_value mrb_kernel_led(mrb_state *mrb, mrb_value self)
{
int value;

	mrb_get_args(mrb, "i", &value);

#if BOARD == BOARD_GR
	digitalWrite( PIN_LED0, value & 1 );
	digitalWrite( PIN_LED1, (value>>1) & 1 );
	digitalWrite( PIN_LED2, (value>>2) & 1 );
	digitalWrite( PIN_LED3, (value>>3) & 1 );
#else
	digitalWrite( RB_LED, value & 1 );
#endif

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 隠しコマンドです:  El_Psy.Congroo
//	El_Psy.Congroo()
//**************************************************
mrb_value mrb_El_Psy_congroo(mrb_state *mrb, mrb_value self)
{
	mrb_raise(mrb, mrb_class_get(mrb, "Sys#exit Called"), "Normal Completion");

	return mrb_nil_value();	//戻り値は無しですよ。
}

//**************************************************
// ライブラリを定義します
//**************************************************
void kernel_Init(mrb_state *mrb)
{
	mrb_define_method(mrb, mrb->kernel_module, "pinMode", mrb_kernel_pinMode, MRB_ARGS_REQ(2));

	mrb_define_method(mrb, mrb->kernel_module, "digitalWrite", mrb_kernel_digitalWrite, MRB_ARGS_REQ(2));
	mrb_define_method(mrb, mrb->kernel_module, "pwm", mrb_kernel_pwm, MRB_ARGS_REQ(2));
	mrb_define_method(mrb, mrb->kernel_module, "digitalRead", mrb_kernel_digitalRead, MRB_ARGS_REQ(1));
	mrb_define_method(mrb, mrb->kernel_module, "analogRead", mrb_kernel_analogRead, MRB_ARGS_REQ(1));

	mrb_define_method(mrb, mrb->kernel_module, "pwmHz", mrb_kernel_pwmHz, MRB_ARGS_REQ(1));
	mrb_define_method(mrb, mrb->kernel_module, "analogDac", mrb_kernel_analogDac, MRB_ARGS_REQ(1));

	mrb_define_method(mrb, mrb->kernel_module, "delay", mrb_kernel_delay, MRB_ARGS_REQ(1));
	mrb_define_method(mrb, mrb->kernel_module, "millis", mrb_kernel_millis, MRB_ARGS_NONE());
	mrb_define_method(mrb, mrb->kernel_module, "micros", mrb_kernel_micros, MRB_ARGS_NONE());

	mrb_define_method(mrb, mrb->kernel_module, "led", mrb_kernel_led, MRB_ARGS_REQ(1));


	struct RClass *El_PsyModule = mrb_define_module(mrb, "El_Psy");
	mrb_define_module_function(mrb, El_PsyModule, "Congroo", mrb_El_Psy_congroo, MRB_ARGS_NONE());
}
