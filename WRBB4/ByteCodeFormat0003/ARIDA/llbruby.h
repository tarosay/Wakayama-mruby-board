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

//バイトコードバージョンを定義します
#define BYTE_CODE2	2
#define BYTE_CODE3	3

//ファームウェアのバージョンを定義します
#define MASTER		1000
#define JAM			1001
#define SDBT		1002
#define SDWF		1003


//基板の設計バージョンを定義します
#define BOARD_GR	0
#define BOARD_P01	1
#define BOARD_P02	2
#define BOARD_P03	3
#define BOARD_P04	4


//バイトコードフォーマットの設定
//#define BYTECODE	BYTE_CODE2
#define BYTECODE	BYTE_CODE3

//基板のタイプ設定
//#define BOARD	BOARD_GR
//#define BOARD	BOARD_P01
//#define BOARD	BOARD_P02
//#define BOARD	BOARD_P03
#define BOARD	BOARD_P04

//ファームウェア設定
#define FIRMWARE	MASTER
//#define FIRMWARE	JAM
//#define FIRMWARE	SDBT
//#define FIRMWARE	SDWF

//#define    DEBUG                1        // Define if you want to debug

#ifdef DEBUG
#  define DEBUG_PRINT(m,v)    { Serial.print("** "); Serial.print((m)); Serial.print(":"); Serial.println((v)); }
#else
#  define DEBUG_PRINT(m,v)    // do nothing
#endif

#define	FILE_LOAD	PORT3.PIDR.BIT.B5		//PORT 3-5

#define XML_FILENAME  "wrbb.xml"
#define RUBY_FILENAME  "main.mrb"
#define RUBY_FILENAME_SIZE 32

#if BOARD == BOARD_GR || BOARD == BOARD_P02 || BOARD == BOARD_P03 || BOARD == BOARD_P04
	#define REALTIMECLOCK	1
#endif


#if BOARD == BOARD_GR
	#if BYTECODE == BYTE_CODE2
		#if FIRMWARE == MASTER
			#define WRBB_VERSION "SakuRuby-1.13(2015/7/19)f2"
		#elif FIRMWARE == JAM
			#define WRBB_VERSION "SakuraJam-1.13(2015/7/19)f2"
		#endif
	#elif BYTECODE == BYTE_CODE3
		#if FIRMWARE == MASTER
			#define WRBB_VERSION "SakuRuby-1.29(2015/12/14)f3"
		#elif FIRMWARE == JAM
			#define WRBB_VERSION "SakuraJam-1.29(2015/12/14)f3"
		#endif
	#endif

	#define RB_PIN0		0
	#define RB_PIN1		1
	#define RB_PIN18	18
	#define RB_PIN19	19
	#define RB_PIN2		2
	#define RB_PIN3		3
	#define RB_PIN4		4
	#define RB_PIN5		5
	#define RB_PIN6		6
	#define RB_PIN7		7
	#define RB_PIN8		8
	#define RB_PIN9		9
	#define RB_PIN10	10
	#define RB_PIN11	11
	#define RB_PIN12	12
	#define RB_PIN13	13
	#define RB_PIN14	14
	#define RB_PIN15	15
	#define RB_PIN16	16
	#define RB_PIN17	17

	#define RB_PIN20	20
	#define RB_PIN21	21
	#define RB_PIN22	22
	#define RB_PIN23	23
	#define RB_PIN24	24
	#define RB_PIN25	25

#elif BOARD == BOARD_P01
	#if BYTECODE == BYTE_CODE2
		#if FIRMWARE == MASTER
			#define WRBB_VERSION "ARIDA1-1.13(2015/7/19)f2"
		#elif FIRMWARE == JAM
			#define WRBB_VERSION "UmeJam1-1.13(2015/7/19)f2"
		#endif
	#elif BYTECODE == BYTE_CODE3
		#if FIRMWARE == MASTER
			#define WRBB_VERSION "ARIDA1-1.29(2015/12/15)f3"
		#elif FIRMWARE == JAM
			#define WRBB_VERSION "UmeJam1-1.29(2015/12/15)f3"
		#endif
	#endif

	#define RB_PIN0		1
	#define RB_PIN1		0
	#define RB_PIN18	22
	#define RB_PIN19	23
	#define RB_PIN2		8
	#define RB_PIN3		30
	#define RB_PIN4		31
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

	#define RB_PIN20	33
	#define RB_PIN21	29
	#define RB_PIN22	5
	#define RB_PIN23	45
	#define RB_PIN24	54
	#define RB_PIN25	100

#elif BOARD == BOARD_P02
	#if BYTECODE == BYTE_CODE2
		#if FIRMWARE == MASTER
			#define WRBB_VERSION "ARIDA2-1.13(2015/7/19)f2"
		#elif FIRMWARE == JAM
			#define WRBB_VERSION "UmeJam2-1.13(2015/7/19)f2"
		#elif FIRMWARE == SDBT
			#define WRBB_VERSION "SDBT2-1.13(2015/7/19)f2"
		#endif
	#elif BYTECODE == BYTE_CODE3
		#if FIRMWARE == MASTER
			#define WRBB_VERSION "ARIDA2-1.29(2015/12/15)f3"
		#elif FIRMWARE == JAM
			#define WRBB_VERSION "UmeJam2-1.29(2015/12/15)f3"
		#elif FIRMWARE == SDBT
			#define WRBB_VERSION "SDBT2-1.29(2015/12/15)f3"
		#endif
	#endif

	#define RB_PIN0		1
	#define RB_PIN1		0
	#define RB_PIN18	30
	#define RB_PIN19	31
	#define RB_PIN2		22
	#define RB_PIN3		23
	#define RB_PIN4		8
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

	#define RB_PIN20	33
	#define RB_PIN21	29
	#define RB_PIN22	5
	#define RB_PIN23	45
	#define RB_PIN24	54
	#define RB_PIN25	100

#elif BOARD == BOARD_P04
	#if BYTECODE == BYTE_CODE3
		#if FIRMWARE == MASTER
			#define WRBB_VERSION "ARIDA4-1.29(2015/12/8)f3"
		#elif FIRMWARE == JAM
			#define WRBB_VERSION "UmeJam4-1.29(2015/12/15)f3"
		#elif FIRMWARE == SDBT
			#define WRBB_VERSION "SDBT4-1.29(2015/12/15)f3"
		#elif FIRMWARE == SDWF
			#define WRBB_VERSION "SDWF2-1.15(2015/10/23)f3"
		#endif
	#endif

	#define RB_PIN0		1
	#define RB_PIN1		0
	#define RB_PIN18	30
	#define RB_PIN19	31
	#define RB_PIN2		22
	#define RB_PIN3		23
	#define RB_PIN4		8
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

	#define RB_PIN20	33
	#define RB_PIN21	29
	#define RB_PIN22	5
	#define RB_PIN23	45
	#define RB_PIN24	54
	#define RB_PIN25	100

#endif

#define RB_LED	PIN_LED0


#endif // _LLBRUBY_H_

