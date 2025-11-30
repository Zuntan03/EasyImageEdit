@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\ComfyUI\models\text_encoders"

@REM https://huggingface.co/Comfy-Org/z_image_turbo/tree/main/split_files/text_encoders
call "%HF_DOWNLOAD%" ".\" "qwen_3_4b.safetensors" "Comfy-Org/z_image_turbo" "split_files/text_encoders/"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
