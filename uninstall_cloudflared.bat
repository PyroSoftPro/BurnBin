@echo off
echo ========================================
echo   Uninstalling Cloudflared
echo ========================================
echo.

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo Checking for cloudflared installation...
echo.

REM Check if cloudflared exists
cloudflared --version >nul 2>&1
if %errorlevel% neq 0 (
    echo cloudflared is not installed or not found in PATH.
    echo.
    pause
    exit /b 0
)

echo Found cloudflared installation.
echo.

REM Try to find cloudflared.exe location
where cloudflared >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where cloudflared') do (
        set "CLOUDFLARED_PATH=%%i"
        echo Found at: %%i
    )
) else (
    set "CLOUDFLARED_PATH="
)

REM Try uninstalling via winget first
echo Attempting to uninstall via winget...
where winget >nul 2>&1
if %errorlevel% equ 0 (
    winget uninstall --id Cloudflare.cloudflared --accept-source-agreements 2>nul
    if %errorlevel% equ 0 (
        echo Successfully uninstalled via winget!
        echo.
        echo Please restart BurnBin to see the changes.
        echo.
        pause
        exit /b 0
    )
)

REM Try removing from System32
if exist "C:\Windows\System32\cloudflared.exe" (
    echo Removing from System32...
    del /f /q "C:\Windows\System32\cloudflared.exe" 2>nul
    if %errorlevel% equ 0 (
        echo Successfully removed from System32.
    )
)

REM Try removing from Program Files
if exist "C:\Program Files\Cloudflare\cloudflared.exe" (
    echo Removing from Program Files...
    rmdir /s /q "C:\Program Files\Cloudflare" 2>nul
    if %errorlevel% equ 0 (
        echo Successfully removed from Program Files.
    )
)

REM Try removing from Program Files (x86)
if exist "C:\Program Files (x86)\Cloudflare\cloudflared.exe" (
    echo Removing from Program Files (x86)...
    rmdir /s /q "C:\Program Files (x86)\Cloudflare" 2>nul
    if %errorlevel% equ 0 (
        echo Successfully removed from Program Files (x86).
    )
)

REM Try removing from local app data
if exist "%LOCALAPPDATA%\cloudflared\cloudflared.exe" (
    echo Removing from Local AppData...
    rmdir /s /q "%LOCALAPPDATA%\cloudflared" 2>nul
    if %errorlevel% equ 0 (
        echo Successfully removed from Local AppData.
    )
)

REM Check if still exists
cloudflared --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ========================================
    echo   Successfully uninstalled!
    echo ========================================
    echo.
    echo Please restart BurnBin to see the changes.
    echo.
) else (
    echo.
    echo cloudflared is still accessible.
    echo.
    echo It may be in a custom location or PATH.
    echo.
    echo Please manually remove it or check your PATH.
    echo.
)

pause

