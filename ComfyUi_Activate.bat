@echo off
call %~dp0EasyImageEdit\ComfyUi\ActivateComfyUi.bat
if %ERRORLEVEL% neq 0 ( exit /b 1 )
cmd /k
