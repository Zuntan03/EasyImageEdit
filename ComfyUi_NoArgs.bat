@echo off
chcp 65001 > NUL

if not exist %~dp0ComfyUI\ (
	echo call %~dp0Update.bat
	call %~dp0Update.bat
)
if not exist %~dp0ComfyUI\ (
	echo "[Error] %~dp0ComfyUI\ が見つかりません。"
	pause & exit /b 1
)

if not exist EasyImageEdit\ComfyUi\.venv\ (
	echo call %~dp0Update.bat
	call %~dp0Update.bat
)
if not exist EasyImageEdit\ComfyUi\.venv\ (
	echo "[Error] EasyImageEdit\ComfyUi\.venv\ が見つかりません。"
	pause & exit /b 1
)

call %~dp0EasyImageEdit\ComfyUi\ActivateComfyUi.bat
if %ERRORLEVEL% neq 0 ( exit /b 1 )

@REM Cuda 2.6.0 以降の Ultratics Error 回避
echo set TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1
set TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1

echo python main.py %*
python main.py %*
if %ERRORLEVEL% neq 0 (
	echo "NVIDIA グラフィックスドライバの更新すると、正常に動作する可能性があります。"
	pause & popd & exit /b 1
)
