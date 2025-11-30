@echo off
chcp 65001 > NUL
cd /d "%~dp0"

set PYTHONUTF8=1

@REM Cuda 2.6.0 以降の Ultratics Error 回避
echo set TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1
set TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1

call "%~dp0..\..\EasyEnv\Uv\PythonActivate.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

call "%~dp0..\..\EasyEnv\Git\SetGitPath.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

cd /d "%~dp0..\..\ComfyUI"
