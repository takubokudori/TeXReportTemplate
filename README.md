# TeXReportTemplate
TeXレポート用テンプレート

# tx.bat
TeXに限らずC,C++,Java,DOTファイルをコンパイルするバッチファイル

TeXファイルの場合はplatex -> dvipdfmx -> pdfファイル の順でコマンドを実行してコンパイルを行います．

## 使い方
```
tx.bat [コンパイルしたいファイル名]
```

ファイル名に拡張子を含めない場合はTeXファイルとみなして行います．

コンパイルに成功するとtx.logファイルをカレントフォルダに設置します．

引数を指定せずにtx.batを実行するとこのファイルを参照して，前回と同じファイルをコンパイルしようとします．

tx.logファイルにそれ以外の用途はないので不要であれば削除してください．

## 依存
[abtexinst](https://www.ms.u-tokyo.ac.jp/~abenori/soft/abtexinst.html)

[jlistings.sty](https://ja.osdn.net/projects/mytexpert/downloads/26068/jlisting.sty.bz2/)

[subfigure.ins](https://ctan.org/tex-archive/obsolete/macros/latex/contrib/subfigure)

[mathtools](https://ctan.org/tex-archive/macros/latex/contrib/mathtools)

styはw32tex\share\texmf-dist\tex\latexに入れるだけ

insは `latex xxx.ins` を実行して w32tex\share\texmf-dist\tex\latex\xxx にinsファイルなどごと入れる
