/*
 * 呼び出し実行モジュールプログラム 2015.6.26 Ver.ARIDA
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

//#include "lua/lua.h"
//#include "lua/lualib.h"
//#include "lua/lauxlib.h"

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
bool Serial_print_error(mrb_state *mrb, mrb_value obj);



#endif // _SEXEC_H_