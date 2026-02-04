@echo off
setlocal EnableExtensions
title Stop VNCServer -> Download & Run Steam + Brave
color 0A

cd /d "%~dp0"

echo.
echo ============================================
echo [1] STOP vncserver.exe + child processes
echo ============================================

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"$targets = Get-Process -Name vncserver -ErrorAction SilentlyContinue; ^
if(!$targets){ Write-Host 'vncserver.exe tidak ditemukan, lanjut...'; exit 0 } ^
function Stop-Tree($p){ ^
  $children = Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $p.Id }; ^
  foreach($c in $children){ ^
    try { Stop-Tree (Get-Process -Id $c.ProcessId -ErrorAction Stop) } catch {} ^
  } ^
  try { Stop-Process -Id $p.Id -Force -ErrorAction Stop; Write-Host ('Stopped PID ' + $p.Id) } catch {} ^
} ^
foreach($p in $targets){ Stop-Tree $p }"

echo.
echo ============================================
echo [2] DOWNLOAD Steam + Brave
echo ============================================

REM Steam Windows installer
set "STEAM_URL=https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe"
set "STEAM_OUT=%~dp0SteamSetup.exe"

REM Brave Windows x64 (nama file resmi)
set "BRAVE_URL=https://laptop-updates.brave.com/latest/winx64"
set "BRAVE_OUT=%~dp0BraveBrowserSetup.exe"

echo.
echo Download Steam...
curl -L --fail --retry 3 --retry-delay 2 "%STEAM_URL%" -o "%STEAM_OUT%"
if errorlevel 1 goto :dl_fail

echo Download Brave...
curl -L --fail --retry 3 --retry-delay 2 "%BRAVE_URL%" -o "%BRAVE_OUT%"
if errorlevel 1 goto :dl_fail

echo.
echo ============================================
echo [3] RUN installers
echo ============================================

if exist "%STEAM_OUT%" (
    echo Menjalankan Steam installer...
    start "" "%STEAM_OUT%"
) else (
    echo Steam installer tidak ditemukan.
)

if exist "%BRAVE_OUT%" (
    echo Menjalankan Brave installer...
    start "" "%BRAVE_OUT%"
) else (
    echo Brave installer tidak ditemukan.
)

echo.
echo Selesai.
pause
exit /b 0

:dl_fail
echo.
echo [ERROR] Download gagal.
echo Cek koneksi / izin / antivirus.
pause
exit /b 1
