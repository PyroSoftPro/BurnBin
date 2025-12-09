@echo off
echo ========================================
echo   BurnBin - Executable Builder
echo ========================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH.
    echo Please install Python from https://www.python.org/downloads/
    pause
    exit /b 1
)

REM Check if PyInstaller is installed
echo Checking for PyInstaller...
python -c "import PyInstaller" 2>nul
if errorlevel 1 (
    echo PyInstaller not found. Installing...
    pip install pyinstaller
    if errorlevel 1 (
        echo Failed to install PyInstaller.
        echo Please install manually: pip install pyinstaller
        pause
        exit /b 1
    )
    echo PyInstaller installed successfully.
    echo.
)

REM Clean previous builds
echo Cleaning previous builds...
if exist "dist" rmdir /s /q "dist"
if exist "build" rmdir /s /q "build"
echo Clean complete.
echo.

REM Create uploads directory if it doesn't exist (needed for packaging)
if not exist "uploads" mkdir "uploads"

echo Building executable...
echo This may take a few minutes...
echo.

REM Build with PyInstaller using spec file
python -m PyInstaller BurnBin.spec

if errorlevel 1 (
    echo.
    echo ========================================
    echo   BUILD FAILED!
    echo ========================================
    echo.
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   BUILD SUCCESSFUL!
echo ========================================
echo.
echo Executable created: dist\BurnBin.exe
echo.
echo File size: 
dir dist\BurnBin.exe | find "BurnBin.exe"
echo.
echo You can now distribute BurnBin.exe as a standalone application.
echo.
echo NOTE: Users will still need cloudflared installed on their system.
echo       The executable includes all Python dependencies.
echo.
pause

