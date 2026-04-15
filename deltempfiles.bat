@echo off

net session >nul 2>&1
if %errorlevel% equ 0 (
    goto :admin_ok
) else (
    goto :get_admin
)

:get_admin
set "vbs=%temp%\getadmin.vbs"
echo Set UAC = CreateObject^("Shell.Application"^) > "%vbs%"
echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %*", "", "runas", 1 >> "%vbs%"

"%vbs%"
del "%vbs%"
exit /b

:admin_ok
cd /d "%~dp0"

setlocal enabledelayedexpansion

set folderlist=%TEMP% %SystemRoot%\Temp

echo Starting cleaning...
echo ------------------------------------------

for %%a in (%folderlist%) do (
    if exist "%%a" (
        echo Cleaning: %%a
        
        pushd "%%a"
        del /s /q /f * 2>nul
        for /d %%p in (*) do rd /s /q "%%p" 2>nul
        popd
        
        echo Done!
        echo.
    ) else (
        echo Folder not found: %%a
    )
)

echo ------------------------------------------
pause
