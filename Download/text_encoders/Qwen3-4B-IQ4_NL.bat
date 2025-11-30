@echo off
chcp 65001 > NUL
setlocal
set "HF_DOWNLOAD=%~dp0..\..\EasyEnv\Aria2\HuggingfaceDownload.bat"
pushd "%~dp0..\..\ComfyUI\models\text_encoders"

@REM https://huggingface.co/unsloth/Qwen3-4B-GGUF
call "%HF_DOWNLOAD%" ".\" "Qwen3-4B-IQ4_NL.gguf" "unsloth/Qwen3-4B-GGUF"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd
endlocal
