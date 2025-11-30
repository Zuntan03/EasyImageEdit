@echo off
chcp 65001 > NUL

set "PROJECT_NAME=EasyImageEdit"

@REM https://www.7-zip.org/
set "SZR_VERSION=25.01"

@REM https://github.com/GyanD/codexffmpeg/releases/
set "FFMPEG_VERSION=8.0.1"

@REM https://github.com/git-for-windows/git/releases
set "GIT_VERSION=2.52.0"

@REM https://github.com/astral-sh/uv/releases
set "UV_VERSION=0.9.13"

@REM https://github.com/aria2/aria2/releases
set "ARIA2_VERSION=1.37.0"

@REM Installer.bat DEBUG
if exist "%~dp0Setup%PROJECT_NAME%.bat" if "%~1"=="DEBUG" (
	copy /y "%~0" "%~dp0..\..\%~nx0" > NUL 2>&1
	cd /d "%~dp0..\..\"
	start "" /b /wait cmd /c "%~nx0 DEBUG"
	cd /d "%~dp0"
	exit /b 0
)

set "PROJECT_DIR=%~dp0"
set "PROJECT_DIR=%PROJECT_DIR:~0,-1%"
set "PROJECT_URL=https://github.com/Zuntan03/%PROJECT_NAME%"
set "PROJECT_BRANCH=main"
set "EASY_ENV_DIR=%~dp0EasyEnv"
set "EASY_ENV_URL=https://github.com/Zuntan03/EasyEnv"
set "EASY_ENV_BRANCH=main"

echo.
echo PROJECT_NAME: %PROJECT_NAME%
echo PROJECT_DIR: %PROJECT_DIR%
echo PROJECT_URL: %PROJECT_URL%
echo PROJECT_BRANCH: %PROJECT_BRANCH%
echo EASY_ENV_DIR: %EASY_ENV_DIR%
echo EASY_ENV_URL: %EASY_ENV_URL%
echo EASY_ENV_BRANCH: %EASY_ENV_BRANCH%
echo.
echo 7ZR_VERSION: %SZR_VERSION%
echo FFMPEG_VERSION: %FFMPEG_VERSION%
echo GIT_VERSION: %GIT_VERSION%
echo UV_VERSION: %UV_VERSION%
echo ARIA2_VERSION: %ARIA2_VERSION%
echo.

if not exist "C:\Windows\System32\where.exe" (
	echo "[ERROR] C:\Windows\System32\where.exe が見つかりません。"
	echo "[ERROR] C:\Windows\System32\where.exe not found."
	pause & exit /b 1
)

where /Q PowerShell
if %ERRORLEVEL% neq 0 (
	echo "[ERROR] PowerShell が見つかりません。"
	echo.
	echo "[ERROR] PowerShell not found."
	pause & exit /b 1
)
set "PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass"

%PS_CMD% -c "if ('%~dp0' -match '^[a-zA-Z0-9:_\\/-]+$') {exit 0}; exit 1"
if %ERRORLEVEL% neq 0 (
	echo "[ERROR] 現在のフォルダパス %~dp0 に英数字・ハイフン・アンダーバー以外が含まれています。"
	echo "英数字・ハイフン・アンダーバーのフォルダパスに bat ファイルを移動して、再実行してください。"
	echo "[ERROR] The current folder path %~dp0 contains characters other than alphanumeric, hyphen, and underscore."
	echo "Move the bat file to a folder path with alphanumeric, hyphen, and underscore, and run it again."
	pause & exit /b 1
)

set "CURL_EXE=C:\Windows\System32\curl.exe"
if not exist %CURL_EXE% (
	echo "[ERROR] %CURL_EXE% が見つかりません。"
	echo "[ERROR] %CURL_EXE% not found."
	pause & exit /b 1
)
set "CURL_CMD=C:\Windows\System32\curl.exe -fkL"

for %%f in ("%~dp0\*") do (
	if not "%%~nxf"=="%~nx0" if not "%~1"=="DEBUG" (
		echo "[ERROR] インストール先のフォルダに他のファイルが存在します。: %%~nxf"
		echo "インストール先のフォルダには %~nx0 しか存在しないようにしてください。"
		echo "[ERROR] There are other files in the installation folder.: %%~nxf"
		echo "There should be only %~nx0 in the installation folder."
		pause & exit /b 1
	)
)

for /d %%d in ("%~dp0\*") do (
	if not "%%~nxd"=="EasyEnv" if not "%~1"=="DEBUG" (
		echo "[ERROR] インストール先のフォルダに他のフォルダが存在します。"
		echo "インストール先のフォルダには %~nx0 しか存在しないようにしてください。"
		echo "[ERROR] There are other folders in the installation folder."
		echo "There should be only %~nx0 in the installation folder."
		pause & exit /b 1
	)
)

if "%~1"=="DEBUG" ( goto :SKIP_ADULT_VERIFY )
echo "このソフトは未成年の方は利用できません。成人していますか？ (y/n)"
echo "This software is not available for minors. Are you an adult? (y/n)"
set /p ADULT_VERIFY=
if /i not "%ADULT_VERIFY%"=="y" (
	echo "インストールを中止します。"
	echo "Installation will be canceled."
	pause & exit /b 1
)
:SKIP_ADULT_VERIFY

echo "動作に必要なファイルを自動ダウンロードします。よろしいですか？ [y/n]（空欄なら y）"
echo "Download necessary files automatically. Are you sure? [y/n] (default: y)"
set /p DOWNLOAD_MODEL=

if not exist "%EASY_ENV_DIR%\Git" ( mkdir "%EASY_ENV_DIR%\Git" )
echo %GIT_VERSION%> "%EASY_ENV_DIR%\Git\GitVersion.txt"
if "%~1"=="DEBUG" ( goto :SKIP_GIT_CLONE )
pushd "%EASY_ENV_DIR%\Git"

@REM ---------- Sync start SetGitPath.bat, Installer.bat ----------
setlocal

if "%EASY_GIT_USE_PORTABLE%" neq "" (  goto :USE_PORTABLE_GIT )
where /Q git
if %ERRORLEVEL% equ 0 ( endlocal & goto :GIT_EXISTS )
cd>NUL 2>&1
:USE_PORTABLE_GIT

set "CURL_CMD=C:\Windows\System32\curl.exe -fkL"

@REM https://github.com/git-for-windows/git/releases
if "%GIT_VERSION%" equ "" ( set "GIT_VERSION=2.51.2" )

if "%~1" neq "" (
	echo %~1> "%CD%\GitVersion.txt"
)
if exist "%CD%\GitVersion.txt" (
	set /p GIT_VERSION=<"%CD%\GitVersion.txt"
) else (
	echo %GIT_VERSION%> "%CD%\GitVersion.txt"
)
if exist "%CD%\%GIT_VERSION%\bin\git.exe" goto :GIT_INSTALLED

set "GIT_ZIP_NAME=PortableGit-%GIT_VERSION%-64-bit.7z.exe"
set "GIT_ZIP_URL=https://github.com/git-for-windows/git/releases/download/v%GIT_VERSION%.windows.1/%GIT_ZIP_NAME%"
set "GIT_ZIP_PATH=%CD%\%GIT_ZIP_NAME%"

echo %CURL_CMD% -o "%GIT_ZIP_PATH%" "%GIT_ZIP_URL%"
%CURL_CMD% -o "%GIT_ZIP_PATH%" "%GIT_ZIP_URL%"
if %ERRORLEVEL% neq 0 (
	echo Failed to download GIT. "%GIT_ZIP_URL%" "%GIT_ZIP_PATH%"
	pause & endlocal & popd & exit /b 1
)

set "SZR_EXE_NAME=7zr.exe"
set "SZR_EXE_URL=https://www.7-zip.org/a/%SZR_EXE_NAME%"
set "SZR_EXE_PATH=%CD%\7zr\%SZR_EXE_NAME%"

if exist "%SZR_EXE_PATH%" ( goto :7ZR_INSTALLED )

if not exist "%CD%\7zr\" ( mkdir "%CD%\7zr\" )

echo %CURL_CMD% -o "%SZR_EXE_PATH%" "%SZR_EXE_URL%"
%CURL_CMD% -o "%SZR_EXE_PATH%" "%SZR_EXE_URL%"
if %ERRORLEVEL% neq 0 (
	echo Failed to download 7zr. "%SZR_EXE_URL%" "%SZR_EXE_PATH%"
	pause & endlocal & popd & exit /b 1
)

:7ZR_INSTALLED

echo %SZR_EXE_PATH% x -o"%CD%\%GIT_VERSION%\" "%GIT_ZIP_PATH%" -y
%SZR_EXE_PATH% x -o"%CD%\%GIT_VERSION%\" "%GIT_ZIP_PATH%" -y
if %ERRORLEVEL% neq 0 (
	echo Failed to extract Git. "%GIT_ZIP_PATH%"
	pause & endlocal & popd & exit /b 1
)

echo del /f /q "%GIT_ZIP_PATH%"
del /f /q "%GIT_ZIP_PATH%"

echo start /b "" "%CD%\%GIT_VERSION%\post-install.bat"
start /b "" "%CD%\%GIT_VERSION%\post-install.bat"

:GIT_INSTALLED

echo "%PATH%" | find /i "%CD%\%GIT_VERSION%\bin" >NUL
if %ERRORLEVEL% equ 0 ( endlocal & goto :GIT_EXISTS )

cd>NUL 2>&1
echo set "PATH=%CD%\%GIT_VERSION%\bin;%%PATH%%"
(
	endlocal
	set "PATH=%CD%\%GIT_VERSION%\bin;%PATH%"
)

:GIT_EXISTS
popd

@REM ---------- Sync end SetGitPath.bat, Installer.bat ----------

where /Q git
if %ERRORLEVEL% equ 0 ( goto :GIT_FOUND )
echo "[Error] Git をインストールできませんでした。Git for Windows を手動でインストールしてください。"
echo "[Error] Git could not be installed. Please install Git for Windows manually."
pause & exit /b 1
:GIT_FOUND

call :INIT_REPO %EASY_ENV_DIR% %EASY_ENV_URL% %EASY_ENV_BRANCH%
if %ERRORLEVEL% neq 0 ( exit /b 1 )

call :INIT_REPO %PROJECT_DIR% %PROJECT_URL% %PROJECT_BRANCH%
if %ERRORLEVEL% neq 0 ( exit /b 1 )

:SKIP_GIT_CLONE

if /i not "%DOWNLOAD_MODEL%" == "n" (
	call %~dp0%PROJECT_NAME%\AutoDownload_Enable.bat
)

>"%EASY_ENV_DIR%\7za\7zaVersion.txt" echo %SZR_VERSION%
>"%EASY_ENV_DIR%\Ffmpeg\FfmpegVersion.txt" echo %FFMPEG_VERSION%
>"%EASY_ENV_DIR%\Uv\UvVersion.txt" echo %UV_VERSION%
>"%EASY_ENV_DIR%\Aria2\Aria2Version.txt" echo %ARIA2_VERSION%

echo.
echo call "%EASY_ENV_DIR%\VcRedist\InstallVcRedist.bat"
call "%EASY_ENV_DIR%\VcRedist\InstallVcRedist.bat"

echo.
echo call "%PROJECT_DIR%\%PROJECT_NAME%\Setup%PROJECT_NAME%.bat"
call "%PROJECT_DIR%\%PROJECT_NAME%\Setup%PROJECT_NAME%.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

goto :DELETE_SELF

:INIT_REPO
set INIT_REPO_DIR=%~1
set INIT_REPO_URL=%~2
set INIT_REPO_BRANCH=%~3

if not exist %INIT_REPO_DIR%\ mkdir %INIT_REPO_DIR%
pushd %INIT_REPO_DIR%

echo git init -q
git init -q
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

git remote get-url origin > NUL 2>&1
if %ERRORLEVEL% neq 0 (
	cd > NUL
	setlocal enabledelayedexpansion
	echo git remote add origin %INIT_REPO_URL%
	git remote add origin %INIT_REPO_URL%
	if !ERRORLEVEL! neq 0 ( pause & endlocal & popd & exit /b 1 )
	endlocal
)

echo git fetch
git fetch
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo "git switch %INIT_REPO_BRANCH% 2>NUL || git checkout -b %INIT_REPO_BRANCH%"
git switch %INIT_REPO_BRANCH% 2>NUL || git checkout -b %INIT_REPO_BRANCH%
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

popd rem %INIT_REPO_DIR%
exit /b 0

:DELETE_SELF
if exist "%~0" (
	echo.
	echo del "%~0"
	echo "`The batch file cannot be found.` の表示はエラーではありません。インストールは完了しています。このウィンドウを閉じて次に進んでください。"
	echo "`The batch file cannot be found.` is not an error. The installation is complete. Please close this window and proceed."
	del "%~0"
)
