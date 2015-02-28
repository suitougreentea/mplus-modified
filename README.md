mplus-modified
==============
![Development status: Inactive](https://img.shields.io/badge/Development%20status-Inactive-red.svg)
![Progress: Release](https://img.shields.io/badge/Progress-Release-brightgreen.svg)

M+のビットマップフォントにPowerLineで使えるグリフを追加してPCF形式で出力するプログラム。
生成されるフォントは、gnome-terminalでの利用を想定しています。
現在10pxのみの対応です。

Requirements
------------
* M+ FONTS BITMAP
* bdftopcf (パスが通っている必要があります)

Usage
-----
1. `git clone git@github.com:suitougreentea/mplus-modified.git`
2. M+の以下のフォントを同じフォルダに配置
    1. 和文フォント(`fonts_j/mplus_j**r.bdf`)
    2. 固定幅欧文フォント(10ドットの場合 `fonts_j/mplus_j10r-iso-W4`, 12ドットの場合 `fonts_e/mplus_f12r.bdf`)
    3. 固定幅欧文フォント太字(10ドットの場合 `fonts_j/mplus_j10b-iso.bdf`, 12ドットの場合 `fonts_e/mplus_f12b.bdf`)
3. `perl make.pl <和文フォント> <固定幅欧文フォント> <固定幅欧文フォント太字> appendchars_**.bdf`

Notes
-----
* `W`グリフの5ドット幅化などのパッチは自分で適用してください。
