# Wakayama-mruby-board

　Wakayama.rb のmrubyボードのソースです。
　何より先ずは「公開」ということで、体裁も整えていないのですが、ソースを公開します。

　Wakayama.rbボードのCPUはRenesasのRX63Nです。
　特殊電子回路さんの無償版FreeRXduinoライブラリを用いて作られています。

　プログラムには課題もたくさんあり、mrbgem化もしたいのですが、皆さん、いろいろと助けてください。
　よろしくお願いします。

  バージョンのARIDAやUmeJamの後の数字は基板番号を表します。
  バージョン最後のf2やf3はバイトコードフォーマットの番号です。mruby1.0.0ベースの場合はf2となります。

  mruby ver1.0.0 -> ByteCode Format Ver.0002
  mruby ver1.1.0 -> ByteCode Format Ver.0003
  mruby ver1.2.0 -> ByteCode Format Ver.0003

  Version ARIDA2 - 1.13 (2015/7/19) f3
  
           |   |   |      |      |
           |   |   |      |   ByteCode Format Number
           |   |   |      |
           |   |   |    作成日
           |   |   |
           |   | バージョン番号
           |   |
           |  回路基板番号
           |
         ファームウァエ名称

------
  It is a source of mruby board of Wakayama.rb.
  What than first is that the "open source", I do not have also trimmed appearance, but to publish the source.

  CPU of Wakayama.rb board is RX63N of Renesas.
  It is made using Tokusyudenshikairo's free version FreeRXduino library.

  There are many challenges to the program, but I want to also mrbgem of, everyone, please variously help.
  Thank you.

#How to use Wakayama.rb board
http://www.slideshare.net/MinaoYamamoto/wakayamarb-arida-4

#License
 Wakayama-mruby-board is released under the [MIT License](MITL).

