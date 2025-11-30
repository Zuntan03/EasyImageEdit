@echo off
chcp 65001 > NUL
if not exist "%~dp0ComfyUiVersionUnlock.txt" ( copy NUL "%~dp0ComfyUiVersionUnlock.txt" > NUL )
