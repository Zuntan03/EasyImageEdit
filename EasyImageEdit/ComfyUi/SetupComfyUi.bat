@echo off
chcp 65001 > NUL
setlocal
set "EASY_ENV=%~dp0..\..\EasyEnv"
set "UV_GIT_HUB_PULL=%EASY_ENV%\Uv\UvGitHubPull.bat"
set "JUNCTION=%EASY_ENV%\SymbolicLink\Junction.bat"
pushd "%~dp0"

call "%EASY_ENV%\Git\SetGitPath.bat"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

echo.
@REM バージョン指定

@REM https://github.com/astral-sh/python-build-standalone/releases/
call :DEFINE_VERSION PYTHON_VERSION ".python-version" 3.12

@REM pyproject-base.toml: torch291_cu130, torch271_cu128
call :DEFINE_VERSION TORCH_CUDA_VERSION ".torch_cuda-version" torch291_cu130

@REM uv.lock の競合は --inexact がケアできる範囲のみ。
call "%EASY_ENV%\Uv\PythonSync.bat" --inexact --extra %TORCH_CUDA_VERSION%
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd rem "%~dp0"
pushd "%~dp0..\.."

@REM https://github.com/comfyanonymous/ComfyUI/releases
@REM https://github.com/comfyanonymous/ComfyUI/commits/master/
@REM 2025/11/30 0a6746898d6864d65e2fc7504e5e875f8c19c0ba
@REM 2025/12/02 a17cf1c3871ad582c85c2bb6fddb63ec9c6df0ce
call :GIT_HUB_PULL comfyanonymous ComfyUI master a17cf1c3871ad582c85c2bb6fddb63ec9c6df0ce
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd rem "%~dp0..\.."
pushd "%~dp0..\..\ComfyUI\custom_nodes"

@REM https://github.com/mingyi456/ComfyUI-DFloat11-Extended/commits/master/
@REM 2025/11/28 a4538723928a03ace4c18047668c020dd32feb66
call :GIT_HUB_PULL mingyi456 ComfyUI-DFloat11-Extended master a4538723928a03ace4c18047668c020dd32feb66
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

@REM https://github.com/erosDiffusion/ComfyUI-EulerDiscreteScheduler/commits/master/
@REM 2025/12/02 ac7a096d6370fccee07396fd1b9dc59fd647710b
call :GIT_HUB_PULL erosDiffusion ComfyUI-EulerDiscreteScheduler master ac7a096d6370fccee07396fd1b9dc59fd647710b
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

@REM https://github.com/city96/ComfyUI-GGUF/commits/main/
@REM 2025/11/30 79379af33899e70276fb66075befcd4e05060e81
@REM 2025/12/01 01f8845bf30d89fff293c7bd50187bc59d9d53ea
call :GIT_HUB_PULL city96 ComfyUI-GGUF main 01f8845bf30d89fff293c7bd50187bc59d9d53ea
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

@REM https://github.com/Comfy-Org/ComfyUI-Manager/tags
call :GIT_HUB_PULL Comfy-Org ComfyUI-Manager main 3.37.1
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

@REM https://github.com/Smirnov75/ComfyUI-mxToolkit/commits/main/
call :GIT_HUB_PULL Smirnov75 ComfyUI-mxToolkit main 7f7a0e584f12078a1c589645d866ae96bad0cc35
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

@REM https://github.com/Koko-boya/Comfyui-Z-Image-Utilities/commits/main/
@REM 2025/12/01 56184d4be398a45cefa6ab9285782df62ced1fc7
call :GIT_HUB_PULL Koko-boya Comfyui-Z-Image-Utilities main 56184d4be398a45cefa6ab9285782df62ced1fc7
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

echo git -C Comfyui-Z-Image-Utilities apply --3way "%~dp0Patch\Comfyui-Z-Image-Utilities-vl_model.patch"
git -C Comfyui-Z-Image-Utilities apply --3way "%~dp0Patch\Comfyui-Z-Image-Utilities-vl_model.patch"
if %ERRORLEVEL% neq 0 ( pause & popd & endlocal & exit /b 1 )

@REM https://github.com/rgthree/rgthree-comfy/commits/main/
@REM 2025/11/27 42e73c3c48e8268129a6a1ea6d9766913bfc5435
call :GIT_HUB_PULL rgthree rgthree-comfy main 42e73c3c48e8268129a6a1ea6d9766913bfc5435 DISABLE_UV_ADD
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd rem "%~dp0..\..\ComfyUI\custom_nodes"
pushd "%~dp0..\..\ComfyUI"

@REM シンボリックリンク（失敗は無視）

call %JUNCTION% ..\ComfyUI_models models
call %JUNCTION% ..\ComfyUI_output output

if not exist user\default\workflows\ ( mkdir user\default\workflows )
call %JUNCTION% ..\ComfyUI_workflows user\default\workflows
call %JUNCTION% user\default\workflows\Easy %~dp0Workflow

popd rem "%~dp0..\..\ComfyUI"
endlocal
exit /b 0

@REM ------------------------------------------------------------------
:GIT_HUB_PULL
@REM %1=GITHUB_USER, %2=GITHUB_REPOSITORY, %3=MASTER_BRANCH, %4=デフォルトバージョン
@REM %5=REQUIREMENTS_PATH（省略可、DISABLE_UV_ADD で uv add を無効化）

@REM ハイフンをアンダースコアに置換して変数名を生成
set "REPO_VAR_NAME=%~2"
set "REPO_VAR_NAME=%REPO_VAR_NAME:-=_%"

echo.
call :DEFINE_VERSION "%REPO_VAR_NAME%" "%~dp0.%~2-version" "%~4"
call "%UV_GIT_HUB_PULL%" %~1 %~2 %~3 %%%REPO_VAR_NAME%%% "%~5"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

exit /b 0

@REM ------------------------------------------------------------------
:DEFINE_VERSION
@REM %1=変数名, %2=ファイル名, %3=デフォルト値

@REM 環境変数設定
set "%~1=%~3"

@REM ファイル書き出し（Unlock でなければ）
if not exist "ComfyUiVersionUnlock.txt" ( >"%~2" echo %~3 )

@REM ファイル読み込み
if exist "%~2" ( set /p %~1=<"%~2" )

@REM echo
call echo %~1: %%%~1%%

exit /b 0
