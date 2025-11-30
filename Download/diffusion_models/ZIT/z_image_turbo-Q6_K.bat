@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\..\ComfyUI\models\diffusion_models"

@REM https://huggingface.co/jayn7/Z-Image-Turbo-GGUF
call "%HF_DOWNLOAD%" "ZIT\" "z_image_turbo-Q6_K.gguf" "jayn7/Z-Image-Turbo-GGUF"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
