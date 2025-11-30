@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\..\ComfyUI\models\diffusion_models"

@REM https://huggingface.co/Comfy-Org/z_image_turbo/tree/main/split_files/diffusion_models
call "%HF_DOWNLOAD%" "ZIT\" "z_image_turbo_bf16.safetensors" "Comfy-Org/z_image_turbo" "split_files/diffusion_models/"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
