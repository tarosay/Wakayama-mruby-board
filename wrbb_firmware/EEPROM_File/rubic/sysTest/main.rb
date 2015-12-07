#!mruby
Serial.begin(0, 115200)


#アドレス0x0000から0x0005に{0x3a,0x39,0x38,0x00,0x36}の5バイトのデータを書き込みます
buf = 0x3a.chr+0x39.chr+0x38.chr+0x0.chr+0x36.chr

System.push( 0x0000, buf, 5 )

#アドレス0x0000から5バイトのデータを読み込みます
ans = System.pop(0x0000, 5)

Serial.println(0, ans)

System.setrun('hello.mrb')  #次に実行するプログラム名をセットします

System.exit()  #このプログラムを終了します。
