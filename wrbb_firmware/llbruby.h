/*
 * WRBB Main
 *
 * Copyright (c) 2015 Minao Yamamoto
 *
 * This software is released under the MIT License.
 * 
 * http://opensource.org/licenses/mit-license.php
 *
 * Light weight Lanuage Board Ruby
 * Wakayamarb board 
 *
 */
#ifndef _LLBRUBY_H_
#define _LLBRUBY_H_  1

#define RUBY_CODE_SIZE (1024 * 4)		//4kBまで実行可能とする

//バージョンを定義します
#define VER100	100
#define VER110	110
#define UMEJAM	1000
#define SAKURUBY	1001
#define SAKURAJAM	1002
#define SDBT	1003


//#define MRUBY_VER	VER100
#define MRUBY_VER	VER110
//#define MRUBY_VER	UMEJAM
//#define MRUBY_VER	SAKURUBY
//#define MRUBY_VER	SAKURAJAM
//#define MRUBY_VER	SDBT

#define MASTER	"ARIDA-2.11 (2015/7/19)"

#if defined(MRUBY_VER)
	#if MRUBY_VER == VER100
		#define WRBB_VERSION "ARIDA-1.07 (2015/7/3)"
	#elif MRUBY_VER == VER110
		#define WRBB_VERSION MASTER
	#elif MRUBY_VER == UMEJAM
		#define WRBB_VERSION "UmeJam-3.10 (2015/7/12)"
	#elif MRUBY_VER == SAKURAJAM
		#define WRBB_VERSION "SakuraJam-3.10 (2015/7/12)"
	#elif MRUBY_VER == SAKURUBY
		#define WRBB_VERSION "SakuRuby-2.10 (2015/7/12)"
	#elif MRUBY_VER == SDBT
		#define WRBB_VERSION "SDBT-2.11 (2015/7/19)"
	#endif
#else
	#define WRBB_VERSION MASTER
#endif

//#define    DEBUG                1        // Define if you want to debug

#ifdef DEBUG
#  define DEBUG_PRINT(m,v)    { Serial.print("** "); Serial.print((m)); Serial.print(":"); Serial.println((v)); }
#else
#  define DEBUG_PRINT(m,v)    // do nothing
#endif

#define	FILE_LOAD	PORT3.PIDR.BIT.B5		//PORT 3-5

#define XML_FILENAME  "wrbb.xml"
#define RUBY_FILENAME  "wrbb.mrb"
#define RUBY_FILENAME_SIZE 32

#define RB_PIN0		1
#define RB_PIN1		0
#define RB_PIN5		24
#define RB_PIN6		26
#define RB_PIN7		6
#define RB_PIN8		7
#define RB_PIN9		53
#define RB_PIN10	10
#define RB_PIN11	11
#define RB_PIN12	12
#define RB_PIN13	13
#define RB_PIN14	14
#define RB_PIN15	15
#define RB_PIN16	16
#define RB_PIN17	17

#if defined(MRUBY_VER)
	#if MRUBY_VER == VER100
		#define RB_PIN18	22
		#define RB_PIN19	23
		#define RB_PIN2		8
		#define RB_PIN3		30
		#define RB_PIN4		31
	#else
		#define RB_PIN18	30
		#define RB_PIN19	31
		#define RB_PIN2		22
		#define RB_PIN3		23
		#define RB_PIN4		8
	#endif
#else
	#define RB_PIN18	22
	#define RB_PIN19	23
	#define RB_PIN2		8
	#define RB_PIN3		30
	#define RB_PIN4		31
#endif

#define RB_LED	PIN_LED0


#endif // _LLBRUBY_H_

