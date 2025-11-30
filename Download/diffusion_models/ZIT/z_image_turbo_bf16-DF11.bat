@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\..\ComfyUI\models\diffusion_models"

@REM https://huggingface.co/mingyi456/Z-Image-Turbo-DF11-ComfyUI
call "%HF_DOWNLOAD%" "ZIT\" "z_image_turbo_bf16-DF11.safetensors" "mingyi456/Z-Image-Turbo-DF11-ComfyUI"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
