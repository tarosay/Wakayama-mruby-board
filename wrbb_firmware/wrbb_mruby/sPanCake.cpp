/*
 * PanCake関連
 *
 * Copyright (c) 2015 Minao Yamamoto
 *
 * This software is released under the MIT License.
 * 
 * http://opensource.org/licenses/mit-license.php
 */
#include <rxduino.h>
#include <string.h>

#include <mruby.h>
#include <mruby/string.h>

#include "../llbruby.h"
#include "sKernel.h"

#define  PANCAKE_BAURATE	115200

extern CSerial *serial[];

unsigned char PanSend[96];
int SerialNum = 1;

//**************************************************
// 画面を消去: PanCake.clear
//  PanCake.clear(cn)
//  cn: 色番号
//**************************************************
mrb_value mrb_pancake_Clear(mrb_state *mrb, mrb_value self)
{
int	cn;

	mrb_get_args(mrb, "i", &cn);

	PanSend[1] = 0x4;
	PanSend[2] = 0x0;
	PanSend[3] = (unsigned char)cn;
	
	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 画面に線を引く: PanCake.line
//  PanCake.line(x1,y1,x2,y2,cn)
//  (x1,y1)-(x2,y2)に線を引きます
//  cn: 色番号
//**************************************************
mrb_value mrb_pancake_Line(mrb_state *mrb, mrb_value self)
{
int	x1;
int	y1;
int	x2;
int	y2;
int	cn;

	mrb_get_args(mrb, "iiiii", &x1, &y1, &x2, &y2, &cn);

	PanSend[1] = 0x8;
	PanSend[2] = 0x1;
	PanSend[3] = (unsigned char)x1;
	PanSend[4] = (unsigned char)y1;
	PanSend[5] = (unsigned char)x2;
	PanSend[6] = (unsigned char)y2;
	PanSend[7] = (unsigned char)cn;
	
	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 画面に円を描く: PanCake.circle
//  PanCake.circle(xc, yc, ra, cn)
//  (xc,yc)を中心に円を描く
//  ra: 半径
//  cn: 色番号
//**************************************************
mrb_value mrb_pancake_Circle(mrb_state *mrb, mrb_value self)
{
int	xc;
int	yc;
int	ra;
int	cn;

	mrb_get_args(mrb, "iiii", &xc, &yc, &ra, &cn);

	PanSend[1] = 0x7;
	PanSend[2] = 0xE;
	PanSend[3] = (unsigned char)xc;
	PanSend[4] = (unsigned char)yc;
	PanSend[5] = (unsigned char)ra;
	PanSend[6] = (unsigned char)cn;
	
	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

int hex2int(char s)
{
	// '0' から '9' の文字なら
	if('0' <= s && s <= '9'){
		return(s - '0');
	}
	//'A' から 'F' の文字なら
	else if('A' <= s && s <= 'F'){
		return(s - 'A' + 10);
	}
	//'a' から 'f' の文字なら
	else if('a' <= s && s <= 'f'){
		return(s - 'a' + 10);
	}

	return 0;
}

//**************************************************
// 画面に8x8の絵を描く: PanCake.stamp
//  PanCake.stamp(px, py, tc, string)
//  px,py: 絵の左上座標
//  tc: 透明色
//  string: 16進数の文字列が64個
//**************************************************
mrb_value mrb_pancake_Stamp(mrb_state *mrb, mrb_value self)
{
int	px;
int	py;
int	tc;
mrb_value text;

	mrb_get_args(mrb, "iiiS", &px, &py, &tc, &text);

	PanSend[1] = 0x26;
	PanSend[2] = 0x2;
	PanSend[3] = (unsigned char)px;
	PanSend[4] = (unsigned char)py;
	PanSend[5] = (unsigned char)tc;

	char *s = RSTRING_PTR(text);

	for(int i=0; i<32; i++){
		PanSend[6 + i] = hex2int(s[i*2]) * 16 + hex2int(s[i*2 + 1]);
	}

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 画面に8x8の1色の絵を描く: PanCake.stamp1
//  PanCake.stamp1(px, py, cn, string)
//  px,py: 絵の左上座標
//  cn: 描く色
//  string: 16進数の文字列が16個
//**************************************************
mrb_value mrb_pancake_Stamp1(mrb_state *mrb, mrb_value self)
{
int	px;
int	py;
int	cn;
mrb_value text;

	mrb_get_args(mrb, "iiiS", &px, &py, &cn, &text);

	PanSend[1] = 0xE;
	PanSend[2] = 0x3;
	PanSend[3] = (unsigned char)px;
	PanSend[4] = (unsigned char)py;
	PanSend[5] = (unsigned char)cn;

	char *s = RSTRING_PTR(text);

	for(int i=0; i<8; i++){
		PanSend[6 + i] = hex2int(s[i*2]) * 16 + hex2int(s[i*2 + 1]);
	}

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 画面に組み込み画像を描く: PanCake.image
//  PanCake.image(num)
//  num: 組み込み画像の番号
//**************************************************
mrb_value mrb_pancake_Image(mrb_state *mrb, mrb_value self)
{
int	num;

	mrb_get_args(mrb, "i", &num);

	PanSend[1] = 0x4;
	PanSend[2] = 0x4;
	PanSend[3] = (unsigned char)num;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// ビデオ出力のON/OFF: PanCake.video
//  PanCake.video(sw)
//  sw: スイッチON/OFF[01/00]
//**************************************************
mrb_value mrb_pancake_Video(mrb_state *mrb, mrb_value self)
{
int	sw;

	mrb_get_args(mrb, "i", &sw);

	PanSend[1] = 0x4;
	PanSend[2] = 0x5;
	PanSend[3] = (unsigned char)sw;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 4ch同時に音を鳴らす: PanCake.sound
//  PanCake.sound(o0, s0, o1, s1, o2, s2, o3, s3)
//  o0,o1,o2,o3: オクターブ(0〜4〜7)
//  s0,s1,s2,s3: 音程(0〜b) eはノイズ音
//               HighBits4は音色(0〜3)
//               音を消すのは FF
//**************************************************
mrb_value mrb_pancake_Sound(mrb_state *mrb, mrb_value self)
{
int	o0,o1,o2,o3;
int s0,s1,s2,s3;

	mrb_get_args(mrb, "iiiiiiii", &o0, &s0, &o1, &s1, &o2, &s2, &o3, &s3);

	PanSend[1] = 0xB;
	PanSend[2] = 0x9;
	PanSend[3] = (unsigned char)o0;
	PanSend[4] = (unsigned char)s0;
	PanSend[5] = (unsigned char)o1;
	PanSend[6] = (unsigned char)s1;
	PanSend[7] = (unsigned char)o2;
	PanSend[8] = (unsigned char)s2;
	PanSend[9] = (unsigned char)o3;
	PanSend[10] = (unsigned char)s3;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 1ch音を鳴らす: PanCake.sound1
//  PanCake.sound1(cn, on, sn)
//  cn: チャネル
//  on: オクターブ(0〜4〜7)
//  sn: 音程(0〜b) eはノイズ音
//      HighBits4は音色(0〜3)
//      音を消すのは FF
//**************************************************
mrb_value mrb_pancake_Sound1(mrb_state *mrb, mrb_value self)
{
int	cn, on, sn;

	mrb_get_args(mrb, "iii", &cn, &on, &sn);

	PanSend[1] = 0x6;
	PanSend[2] = 0xA;
	PanSend[3] = (unsigned char)cn;
	PanSend[4] = (unsigned char)on;
	PanSend[5] = (unsigned char)sn;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 初期状態にする: PanCake.reset
//  PanCake.reset()
//**************************************************
mrb_value mrb_pancake_Reset(mrb_state *mrb, mrb_value self)
{
	PanSend[1] = 0x3;
	PanSend[2] = 0xD;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// OUTポートに出力: PanCake.out
//  PanCake.out(pf)
//  pf: HIGHにするポート番号を16進数で指定
//**************************************************
mrb_value mrb_pancake_Out(mrb_state *mrb, mrb_value self)
{
int	pf;

	mrb_get_args(mrb, "i", &pf);

	PanSend[1] = 0x4;
	PanSend[2] = 0xF;
	PanSend[3] = (unsigned char)pf;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// スプライトを開始する: Sprite.start
//  Sprite.start(num)
//  num: 背景に使う組み込み画像番号
//       背景をベタ塗りにする場合は num のHighBitsを1にします。
//      スプライト処理を停止するには num を FF にします。
//**************************************************
mrb_value mrb_pancake_Start(mrb_state *mrb, mrb_value self)
{
int	num;

	mrb_get_args(mrb, "i", &num);

	PanSend[1] = 0x4;
	PanSend[2] = 0x6;
	PanSend[3] = (unsigned char)num;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// スプライトを作る: Sprite.create
//  Sprite.create(sn, si)
//  sn: スプライト番号 0〜15
//  si: 組み込みスプライト画像番号
//      消すのは FF
//**************************************************
mrb_value mrb_pancake_Create(mrb_state *mrb, mrb_value self)
{
int sn, si;

	mrb_get_args(mrb, "ii", &sn, &si);

	PanSend[1] = 0x5;
	PanSend[2] = 0x7;
	PanSend[3] = (unsigned char)sn;
	PanSend[4] = (unsigned char)si;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// スプライトの移動: Sprite.move
//  Sprite.move(sn, px,py)
//  sn: スプライト番号 0〜15
//  px,py: 画面座標
//**************************************************
mrb_value mrb_pancake_Move(mrb_state *mrb, mrb_value self)
{
int sn, px, py;

	mrb_get_args(mrb, "iii", &sn, &px, &py);

	PanSend[1] = 0x6;
	PanSend[2] = 0x8;
	PanSend[3] = (unsigned char)sn;
	PanSend[4] = (unsigned char)px;
	PanSend[5] = (unsigned char)py;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// 音楽再生する: Music.play
//  Music.play(sw)
//  sw: START/STOP[01/00]
//**************************************************
mrb_value mrb_pancake_Play(mrb_state *mrb, mrb_value self)
{
int sw;

	mrb_get_args(mrb, "i", &sw);

	PanSend[1] = 0x4;
	PanSend[2] = 0xC;
	PanSend[3] = (unsigned char)sw;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// MMLをサウンドchに登録する: Music.score
//  Music.score(ch, pn, tt, string)
//  ch: チャンネル(00〜03)
//  pn: 01:即再生、00:後で再生
//  tt: テンポ(0〜F)+音色 [ex. 30 == テンポ3、音色0]
//  string: MML 64バイトまで
//**************************************************
mrb_value mrb_pancake_Score(mrb_state *mrb, mrb_value self)
{
int	ch, pn, tt;
mrb_value text;

	mrb_get_args(mrb, "iiiS", &ch, &pn, &tt, &text);

	//PanSend[1] = 0xE;
	PanSend[2] = 0xB;
	PanSend[3] = (unsigned char)ch;
	PanSend[4] = (unsigned char)pn;
	PanSend[5] = (unsigned char)tt;

	char *s = RSTRING_PTR(text);
	int len = RSTRING_LEN(text);

	for(int i=0; i<len; i++){
		PanSend[6 + i] = s[i];
	}
	PanSend[1] = 6 + len;

	serial[SerialNum]->write( (const unsigned char *)PanSend, PanSend[1]);

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// PanCakeで使うシリアルポート番号を指定: PanCake.serial
//  PanCake.serial(num)
//  num: シリアルポート番号(1〜3)
//**************************************************
mrb_value mrb_pancake_Serial(mrb_state *mrb, mrb_value self)
{
int	num;

	mrb_get_args(mrb, "i", &num);

	if(num<=0 || num>3){
		num = 1;
	}

	SerialNum = num;

	//シリアル通信の初期化をします
	if(serial[SerialNum] != 0){
		serial[SerialNum]->end();
		delay(50);
		delete serial[SerialNum];
	}
	serial[SerialNum] = new CSerial();
	serial[SerialNum]->begin(PANCAKE_BAURATE, SCI_SCI0P2x);
	sci_convert_crlf_ex(serial[SerialNum]->get_handle(), CRLF_NONE, CRLF_NONE);		//バイナリを通せるようにする

	return mrb_nil_value();			//戻り値は無しですよ。
}

//**************************************************
// ライブラリを定義します
//**************************************************
void pancake_Init(mrb_state *mrb)
{	
	PanSend[0] = 0x80;

	struct RClass *pancakeModule = mrb_define_module(mrb, "PanCake");
	mrb_define_module_function(mrb, pancakeModule, "serial", mrb_pancake_Serial, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, pancakeModule, "clear", mrb_pancake_Clear, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, pancakeModule, "line", mrb_pancake_Line, MRB_ARGS_REQ(5));
	mrb_define_module_function(mrb, pancakeModule, "circle", mrb_pancake_Circle, MRB_ARGS_REQ(4));
	mrb_define_module_function(mrb, pancakeModule, "stamp", mrb_pancake_Stamp, MRB_ARGS_REQ(4));
	mrb_define_module_function(mrb, pancakeModule, "stamp1", mrb_pancake_Stamp1, MRB_ARGS_REQ(4));
	mrb_define_module_function(mrb, pancakeModule, "image", mrb_pancake_Image, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, pancakeModule, "video", mrb_pancake_Video, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, pancakeModule, "sound", mrb_pancake_Sound, MRB_ARGS_REQ(8));
	mrb_define_module_function(mrb, pancakeModule, "sound1", mrb_pancake_Sound1, MRB_ARGS_REQ(3));
	mrb_define_module_function(mrb, pancakeModule, "reset", mrb_pancake_Reset, MRB_ARGS_NONE());
	mrb_define_module_function(mrb, pancakeModule, "out", mrb_pancake_Out, MRB_ARGS_REQ(1));


	struct RClass *spriteModule = mrb_define_module(mrb, "Sprite");
	mrb_define_module_function(mrb, spriteModule, "start", mrb_pancake_Start, MRB_ARGS_REQ(1));
	mrb_define_module_function(mrb, spriteModule, "create", mrb_pancake_Create, MRB_ARGS_REQ(2));
	mrb_define_module_function(mrb, spriteModule, "move", mrb_pancake_Move, MRB_ARGS_REQ(3));


	struct RClass *musicModule = mrb_define_module(mrb, "Music");
	mrb_define_module_function(mrb, musicModule, "score", mrb_pancake_Score, MRB_ARGS_REQ(4));
	mrb_define_module_function(mrb, musicModule, "play", mrb_pancake_Play, MRB_ARGS_REQ(1));
}
