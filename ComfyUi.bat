@echo off
chcp 65001 > NUL

@REM --max-upload-size 500
call %~dp0ComfyUi_NoArgs.bat --auto-launch --fast --use-sage-attention %*
