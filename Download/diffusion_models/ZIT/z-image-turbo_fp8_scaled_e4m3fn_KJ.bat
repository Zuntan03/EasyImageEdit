@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\..\ComfyUI\models\diffusion_models"

@REM https://huggingface.co/Kijai/Z-Image_comfy_fp8_scaled
call "%HF_DOWNLOAD%" "ZIT\" "z-image-turbo_fp8_scaled_e4m3fn_KJ.safetensors" "Kijai/Z-Image_comfy_fp8_scaled"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
