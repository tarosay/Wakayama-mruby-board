/*
 * 呼び出し実行モジュールプログラム
 *
 * Copyright (c) 2015 Minao Yamamoto
 *
 * This software is released under the MIT License.
 * 
 * http://opensource.org/licenses/mit-license.php
 */
 
#ifndef _SEXEC_H_
#define _SECEC_H_  1

#include <mruby.h>

#if defined __cplusplus
extern "C" {
#endif


#if defined __cplusplus
}
#endif

//**************************************************
//  mrubyを実行します
//**************************************************
bool RubyRun( void );

//**************************************************
//  エラーメッセージ
//**************************************************
void Serial_print_error(mrb_state *mrb, mrb_value obj);



#endif // _SEXEC_H_