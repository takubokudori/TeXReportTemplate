@echo off
setlocal enabledelayedexpansion

set /A FLAG=1
rem 以前のデータが残ってないか確認する
if "%1" == "" goto USEDBEFORE

rem コンパイル開始，拡張子無しはtexと解釈する
:RESTART
if "%FLAG%"=="1"  (
		set OFP=%~n1
		set FEX=%~x1
	)
if "%FEX%" == "" goto TEXCOMPILE
if "%FEX%" == ".c" goto CCOMPILE
if "%FEX%" == ".cpp"  goto CPPCOMPILE
if "%FEX%" == ".java" goto JAVACOMPILE
if "%FEX%" == ".dot" goto DOTCOMPILE
if "%FEX%" == ".tex" goto TEXCOMPILE
goto :NOTMATCHING
goto :EOF

rem ログデータがあるか確認して，ログデータを代入
:USEDBEFORE
if not exist "tx.log" goto ARGSERROR
for /f "delims=" %%a in (tx.log) do (
		if "!FLAG!" equ "1"  (
			set OFP=%%a
			set /A FLAG=0
		)else set FEX=%%a
		rem echo !OFP!をコンパイルします
		rem echo !FEX!でコンパイルします
	)
echo !OFP!!FEX!をコンパイルします
		goto :RESTART
goto :EOF

:CCOMPILE
	gcc !OFP!.c -o a.exe
	goto WRITELOG
	goto :EOF

:CPPCOMPILE
	g++ !OFP!.cpp -o a.exe
	goto WRITELOG
	goto :EOF

:JAVACOMPILE
	javac !OFP!.java
	goto WRITELOG
	goto :EOF

:DOTCOMPILE
	dot -T jpg !OFP!.dot -o a.jpg
	if %ERRORLEVEL% neq 0 goto DOTFALLED
	a.jpg
	set OFP=%~n1
	goto WRITELOG
	goto :EOF

:TEXCOMPILE
	set FEX=.tex
	platex !OFP!.tex
	if %ERRORLEVEL% neq 0 goto PLATEXFALLED
	dvipdfmx !OFP!
	if %ERRORLEVEL% neq 0 goto DVIPDFMXFALLED
	!OFP!.pdf
	goto WRITELOG
	goto :EOF

rem ログを書き込む
:WRITELOG
if "%FLAG%"=="0" goto :EOF
echo !OFP!>tx.log
echo !FEX!>>tx.log
goto :EOF

:NOTMATCHING
echo 指定されたファイルの拡張子には対応していません
echo 現在対応している拡張子はtex,c,cpp,dot,javaです．
goto :EOF

:ARGSERROR
echo tx.bat説明
echo tx.bat [ファイル名]
echo あらゆるファイルのコンパイルを一連でやります
echo 拡張子を入れなかった場合，texファイルとして認識します
echo txだけコマンドを打った場合，前回実行したファイル名で再実行します
echo ただし，c,cpp,javaを除いて失敗した場合は，保存されません
echo 再実行するファイルはtx.logに記録されます(各フォルダ毎に作成されます)
echo バッチ処理を中断します
goto :EOF

:PLATEXFALLED
echo platexコマンドが失敗しました
echo ファイルが存在しないかファイル中に誤りがあります
echo 入力したファイル名に拡張子を入れていないか確かめてください
echo バッチ処理を中断します
goto :EOF

:DVIPDFMXFALLED
echo dvipdfmxコマンドが失敗しました
echo 他のソフトで既存の同名pdfファイルが開いていないかなどを確かめてください
echo バッチ処理を中断します
goto :EOF

:DOTFALLED
echo dotコマンドが失敗しました
echo ファイルが存在しないかファイル中に誤りがあります
echo バッチ処理を中断します
goto :EOF
