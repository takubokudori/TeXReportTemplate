@echo off
setlocal enabledelayedexpansion

set /A FLAG=1
rem �ȑO�̃f�[�^���c���ĂȂ����m�F����
if "%1" == "" goto USEDBEFORE

rem �R���p�C���J�n�C�g���q������tex�Ɖ��߂���
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

rem ���O�f�[�^�����邩�m�F���āC���O�f�[�^����
:USEDBEFORE
if not exist "tx.log" goto ARGSERROR
for /f "delims=" %%a in (tx.log) do (
		if "!FLAG!" equ "1"  (
			set OFP=%%a
			set /A FLAG=0
		)else set FEX=%%a
		rem echo !OFP!���R���p�C�����܂�
		rem echo !FEX!�ŃR���p�C�����܂�
	)
echo !OFP!!FEX!���R���p�C�����܂�
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

rem ���O����������
:WRITELOG
if "%FLAG%"=="0" goto :EOF
echo !OFP!>tx.log
echo !FEX!>>tx.log
goto :EOF

:NOTMATCHING
echo �w�肳�ꂽ�t�@�C���̊g���q�ɂ͑Ή����Ă��܂���
echo ���ݑΉ����Ă���g���q��tex,c,cpp,dot,java�ł��D
goto :EOF

:ARGSERROR
echo tx.bat����
echo tx.bat [�t�@�C����]
echo ������t�@�C���̃R���p�C������A�ł��܂�
echo �g���q�����Ȃ������ꍇ�Ctex�t�@�C���Ƃ��ĔF�����܂�
echo tx�����R�}���h��ł����ꍇ�C�O����s�����t�@�C�����ōĎ��s���܂�
echo �������Cc,cpp,java�������Ď��s�����ꍇ�́C�ۑ�����܂���
echo �Ď��s����t�@�C����tx.log�ɋL�^����܂�(�e�t�H���_���ɍ쐬����܂�)
echo �o�b�`�����𒆒f���܂�
goto :EOF

:PLATEXFALLED
echo platex�R�}���h�����s���܂���
echo �t�@�C�������݂��Ȃ����t�@�C�����Ɍ�肪����܂�
echo ���͂����t�@�C�����Ɋg���q�����Ă��Ȃ����m���߂Ă�������
echo �o�b�`�����𒆒f���܂�
goto :EOF

:DVIPDFMXFALLED
echo dvipdfmx�R�}���h�����s���܂���
echo ���̃\�t�g�Ŋ����̓���pdf�t�@�C�����J���Ă��Ȃ����Ȃǂ��m���߂Ă�������
echo �o�b�`�����𒆒f���܂�
goto :EOF

:DOTFALLED
echo dot�R�}���h�����s���܂���
echo �t�@�C�������݂��Ȃ����t�@�C�����Ɍ�肪����܂�
echo �o�b�`�����𒆒f���܂�
goto :EOF
