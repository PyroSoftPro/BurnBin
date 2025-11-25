@echo off
echo Starting DRCTSend...
echo.
python main.py
if errorlevel 1 (
    echo.
    echo Error: Python is not installed or not in PATH.
    echo Please install Python from https://www.python.org/downloads/
    pause
)

