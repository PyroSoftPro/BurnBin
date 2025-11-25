@echo off
echo ========================================
echo   Installing Cloudflared for BurnBin
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

echo Checking for existing cloudflared installation...
cloudflared --version >nul 2>&1
if %errorlevel% equ 0 (
    echo cloudflared is already installed!
    cloudflared --version
    echo.
    pause
    exit /b 0
)

echo.
echo Installing cloudflared...
echo.

REM Try winget first (Windows 10/11)
where winget >nul 2>&1
if %errorlevel% equ 0 (
    echo Using winget to install cloudflared...
    winget install --id Cloudflare.cloudflared --accept-package-agreements --accept-source-agreements
    if %errorlevel% equ 0 (
        echo.
        echo ========================================
        echo Installation successful!
        echo ========================================
        echo.
        echo Please restart BurnBin for changes to take effect.
        echo.
        pause
        exit /b 0
    )
)

echo.
echo winget not available. Trying manual download...
echo.

REM Get latest release URL
echo Downloading cloudflared...
set "DOWNLOAD_URL=https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe"
set "TEMP_FILE=%TEMP%\cloudflared-installer.exe"

echo Downloading from: %DOWNLOAD_URL%
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%DOWNLOAD_URL%' -OutFile '%TEMP_FILE%'}"

if not exist "%TEMP_FILE%" (
    echo.
    echo Download failed!
    echo Please download manually from:
    echo https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe
    echo.
    echo Then rename it to cloudflared.exe and place it in a folder in your PATH
    echo (e.g., C:\Windows\System32)
    echo.
    pause
    exit /b 1
)

REM Install to System32
echo Copying to System32...
copy "%TEMP_FILE%" "C:\Windows\System32\cloudflared.exe" >nul 2>&1
if %errorlevel% equ 0 (
    del "%TEMP_FILE%"
    echo.
    echo ========================================
    echo Installation successful!
    echo ========================================
    echo.
    echo cloudflared has been installed to C:\Windows\System32
    echo Please restart BurnBin for changes to take effect.
    echo.
    pause
    exit /b 0
) else (
    echo.
    echo Failed to copy to System32. Trying current directory...
    copy "%TEMP_FILE%" "cloudflared.exe"
    if %errorlevel% equ 0 (
        echo.
        echo Downloaded cloudflared.exe to current directory.
        echo Please add this directory to your PATH or move cloudflared.exe
        echo to a folder that is already in your PATH.
        echo.
        echo.
        pause
        exit /b 0
    ) else (
        echo.
        echo Installation failed!
        echo Please install manually from:
        echo https://github.com/cloudflare/cloudflared/releases
        echo.
        pause
        exit /b 1
    )
)

