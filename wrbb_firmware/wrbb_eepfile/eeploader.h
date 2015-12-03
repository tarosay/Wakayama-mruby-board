/*
 * EEPROM FIle Loader
 *
 * Copyright (c) 2015 Minao Yamamoto
 *
 * This software is released under the MIT License.
 * 
 * http://opensource.org/licenses/mit-license.php
 */

void lineinput(char *arry);
void writefile(const char *fname, int size, char code);
void readfile(const char *fname, char code);
int fileloader(const char* str0, const char* str1);
