@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\ComfyUI\models\text_encoders"

@REM https://huggingface.co/jiangchengchengNLP/qwen3-4b-fp8-scaled
call "%HF_DOWNLOAD%" ".\" "qwen3_4b_fp8_scaled.safetensors" "jiangchengchengNLP/qwen3-4b-fp8-scaled"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
