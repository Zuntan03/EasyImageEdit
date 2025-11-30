@echo off
chcp 65001 > NUL

call "%~dp0ComfyUi/SetupComfyUi.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

if not exist "%~dp0AutoDownload.txt" ( goto :SKIP_AUTO_DOWNLOAD )
call "%~dp0..\Download\Default.bat"
:SKIP_AUTO_DOWNLOAD
