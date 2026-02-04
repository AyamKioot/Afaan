@echo off
title Download & Run Steam + Brave
cd /d "%~dp0"

set "STEAM_URL=https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe"
set "BRAVE_URL=https://laptop-updates.brave.com/latest/winx64"

echo Download Steam...
curl -L "%STEAM_URL%" -o SteamSetup.exe
if errorlevel 1 goto fail

echo Download Brave...
curl -L "%BRAVE_URL%" -o BraveBrowserSetup.exe
if errorlevel 1 goto fail

echo.
echo Menjalankan installer...

start "" "%~dp0SteamSetup.exe"
start "" "%~dp0BraveBrowserSetup.exe"

echo Selesai.
exit /b 0

:fail
echo Download gagal.
pause
exit /b 1
