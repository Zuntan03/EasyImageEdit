@echo off
chcp 65001 > NUL

call "%~dp0EasyEnv\Git\SetGitPath.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )

pushd "%~dp0EasyEnv"
echo.
echo git fetch origin https://github.com/Zuntan03/EasyEnv
git fetch origin
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo git reset --hard origin/main
git reset --hard origin/main
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )
popd rem "%~dp0EasyEnv"

pushd "%~dp0"
echo.
echo git fetch origin https://github.com/Zuntan03/EasyImageEdit
git fetch origin
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )

echo git reset --hard origin/main
git reset --hard origin/main
if %ERRORLEVEL% neq 0 ( pause & popd & exit /b 1 )
popd rem "%~dp0"

call "%~dp0EasyImageEdit\SetupEasyImageEdit.bat"
if %ERRORLEVEL% neq 0 ( exit /b 1 )
