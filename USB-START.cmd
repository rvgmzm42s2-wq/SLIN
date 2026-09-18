@echo off
title SLIN
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0SLIN.ps1" status
echo.
echo Run SLIN.cmd help for commands.
pause
