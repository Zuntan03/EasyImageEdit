@echo off
chcp 65001 > NUL
if exist "%~dp0ComfyUiVersionUnlock.txt" ( del "%~dp0ComfyUiVersionUnlock.txt" > NUL )
