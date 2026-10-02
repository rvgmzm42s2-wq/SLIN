@echo off
title SLIN
setlocal
cd /d "%~dp0"

if not exist "%~dp0config\model.json" (
    echo.
    echo ========================================
    echo        SLIN FULL AI MODEL SETUP
    echo ========================================
    echo.
    echo Downloading and installing the complete
    echo local SLIN model. This may take a while.
    echo.
    powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-model.ps1"
    if errorlevel 1 (
        echo.
        echo SLIN model setup failed.
        pause
        exit /b 1
    )
)

echo.
echo Starting SLIN...
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0SLIN.ps1" chat
