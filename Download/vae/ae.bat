@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\ComfyUI\models\vae"

@REM https://huggingface.co/Comfy-Org/z_image_turbo/tree/main/split_files/vae
call "%HF_DOWNLOAD%" ".\" "ae.safetensors" "Comfy-Org/z_image_turbo" "split_files/vae/"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
