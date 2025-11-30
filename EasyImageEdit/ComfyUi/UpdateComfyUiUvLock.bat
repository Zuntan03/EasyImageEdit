@echo off
chcp 65001 > NUL
setlocal
set "PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass"
set "EASY_ENV=%~dp0..\..\EasyEnv"
pushd "%~dp0"

echo call "%EASY_ENV%\Uv\SetUvPath.bat"
call "%EASY_ENV%\Uv\SetUvPath.bat"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

@REM uv.lock を uv.backup.lock に上書きリネーム
if exist "uv.lock" (
    echo move /y "uv.lock" "uv.backup.lock"
    move /y "uv.lock" "uv.backup.lock" > NUL
)

@REM uv.tree.backup.txt リダイレクトで生成
echo uv tree ^> uv-tree.backup.txt
uv tree > uv-tree.backup.txt

@REM uv.freeze.backup.txt リダイレクトで生成
echo uv pip freeze ^> uv-pip-freeze.backup.txt
uv pip freeze > uv-pip-freeze.backup.txt

@REM pyproject.toml を pyproject.backup.toml に上書きリネーム
if exist "pyproject.toml" (
    echo move /y "pyproject.toml" "pyproject.backup.toml"
    move /y "pyproject.toml" "pyproject.backup.toml" > NUL
)

@REM pyproject-base.toml を pyproject.toml にコピー
echo copy /y "pyproject-base.toml" "pyproject.toml"
copy /y "pyproject-base.toml" "pyproject.toml" > NUL

@REM 環境再構築
if exist ".venv\" (
    echo rmdir /S /Q ".venv"
    rmdir /S /Q ".venv"
)
echo uv sync
uv sync
if %ERRORLEVEL% neq 0 ( pause & popd & endlocal & exit /b 1 )

set "EASY_UV_LOCK_UPDATE_PROJECT=%~dp0"
set "EASY_UV_LOCK_UPDATE_PROJECT=%EASY_UV_LOCK_UPDATE_PROJECT:~0,-1%"
echo set "EASY_UV_LOCK_UPDATE_PROJECT=%EASY_UV_LOCK_UPDATE_PROJECT%"

call "%~dp0SetupComfyUi.bat"
if %ERRORLEVEL% neq 0 ( popd & endlocal & exit /b 1 )

popd rem "%~dp0"
call "%~dp0ActivateComfyUi.bat"
if %ERRORLEVEL% neq 0 ( endlocal & exit /b 1 )

echo.
echo python main.py --quick-test-for-ci --fast --use-sage-attention
@REM python main.py --quick-test-for-ci --fast --use-sage-attention
%PS_CMD% -c "$t = Measure-Command { python main.py --quick-test-for-ci --fast --use-sage-attention }; Write-Host ('ComfyUI startup time: ' + $t.TotalSeconds + ' seconds')"
if %ERRORLEVEL% neq 0 ( endlocal & exit /b 1 )

pushd "%~dp0"

echo uv tree ^> uv-tree.txt
uv tree > uv-tree.txt

echo uv pip freeze ^> uv-pip-freeze.txt
uv pip freeze > uv-pip-freeze.txt

popd rem "%~dp0"
endlocal
