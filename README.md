# Wakayama-mruby-board　ARIDA-1.3(2015/3/22) | ARIDA-2.0(2015/3/22)

　Wakayama.rb のmrubyボードのソースです。
　何より先ずは「公開」ということで、体裁も整えていないのですが、ソースを公開します。

　Wakayama.rbボードのCPUはRenesasのRX63Nです。
　特殊電子回路さんの無償版FreeRXduinoライブラリを用いて作られています。

　プログラムには課題もたくさんあり、mrbgem化もしたいのですが、皆さん、いろいろと助けてください。
　よろしくお願いします。

　mruby ver1.0.0 と mruby ver1.1.0 の両方の対応ソースを同梱しました。firmware1がver1.0.0対応、firmware2がver1.1.0対応です。
　mruby ver1.1.0 はWakayama.rbボードV2.0対応しており、RTCのクラスが実装されています。旧ボードでも動作しますが、RTCは使わないでください。

　mruby ver1.0.0は、ByteCode Format Ver.0002です。
　mruby ver1.1.0は、ByteCode Format Ver.0003です。

　この違いがありますので、firware1とfirmware2を確認して使用してください。

------
  It is a source of mruby board of Wakayama.rb.
  What than first is that the "open source", I do not have also trimmed appearance, but to publish the source.

  CPU of Wakayama.rb board is RX63N of Renesas.
  It is made using Tokusyudenshikairo's free version FreeRXduino library.

  There are many challenges to the program, but I want to also mrbgem of, everyone, please variously help.
  Thank you.

#How to use Wakayama.rb board
http://www.slideshare.net/MinaoYamamoto/wakayamarb-board

#License

    Copyright (c) 2015 Minao Yamamoto

under the MIT License:

http://www.opensource.org/licenses/mit-license.php


#Author

    Minao Yamamoto
