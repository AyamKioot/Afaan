@echo off
title VNC CLEANER - PREMIUM EDITION
color 0A

:: RUN AS ADMIN CHECK
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ========================================
    echo   HARUS RUN AS ADMINISTRATOR GOBLOK!
    echo ========================================
    echo.
    echo Klik kanan - Run as administrator
    echo.
    pause
    exit
)

cls
echo ========================================
echo    REALVNC DESTROYER - BY REQUEST
echo ========================================
echo.
echo [!] Sabar bentar, lagi gw beresin...
echo.

:: STEP 1 - MATIIN PROSES
echo [1/5] Matiin proses VNC...
taskkill /f /im *vnc* /t 2>nul
taskkill /f /im vncserver.exe /t 2>nul
taskkill /f /im winvnc.exe /t 2>nul
taskkill /f /im vncservice.exe /t 2>nul
taskkill /f /im vncserverui.exe /t 2>nul
echo OK!
echo.

:: STEP 2 - STOP SERVICE
echo [2/5] Stop service VNC...
sc stop vncserver 2>nul
sc stop vncservice 2>nul
sc stop vncserver4 2>nul
sc delete vncserver 2>nul
sc delete vncservice 2>nul
sc delete vncserver4 2>nul
echo OK!
echo.

:: STEP 3 - AMBIL ALIH PERMISSION
echo [3/5] Ambil alih kepemilikan folder...
takeown /f "C:\Program Files\RealVNC" /r /d y >nul 2>&1
icacls "C:\Program Files\RealVNC" /grant administrators:F /t /q >nul 2>&1
echo OK!
echo.

:: STEP 4 - HAPUS FOLDER
echo [4/5] Ngehapus folder RealVNC...

if exist "C:\Program Files\RealVNC" (
    echo Folder ditemukan! Dihapus...
    
    :: Hapus paksa pake cara biadab
    rmdir /s /q "C:\Program Files\RealVNC" >nul 2>&1
    
    :: Kalo masih bandel, pake DEL
    if exist "C:\Program Files\RealVNC" (
        del /f /s /q "C:\Program Files\RealVNC\*.*" >nul 2>&1
        rmdir /s /q "C:\Program Files\RealVNC" >nul 2>&1
    )
    
    :: Kalo MASIH bandel juga
    if exist "C:\Program Files\RealVNC" (
        echo Folder masih ada! Pake cara ketiga...
        rd /s /q "C:\Program Files\RealVNC" >nul 2>&1
    )
    
    :: Cek hasil
    if not exist "C:\Program Files\RealVNC" (
        echo [✓] BERHASIL DIHAPUS!
    ) else (
        echo [✗] GAGAL! Folder masih ngebandel.
        echo Coba restart dulu trus jalanin lagi.
    )
) else (
    echo [i] Folder ga ada di C:\Program Files\RealVNC
    echo Cek lokasi lain...
    
    :: Cek lokasi alternatif
    if exist "C:\Program Files (x86)\RealVNC" (
        echo Folder ditemukan di Program Files (x86)!
        rmdir /s /q "C:\Program Files (x86)\RealVNC" >nul 2>&1
        echo [✓] Dihapus!
    )
    
    if exist "%ProgramData%\RealVNC" (
        rmdir /s /q "%ProgramData%\RealVNC" >nul 2>&1
    )
    
    if exist "%AppData%\RealVNC" (
        rmdir /s /q "%AppData%\RealVNC" >nul 2>&1
    )
)
echo.

:: STEP 5 - BERSIHIN REGISTRY
echo [5/5] Sapu bersih registry...
reg delete "HKLM\SOFTWARE\RealVNC" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\RealVNC" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\RealVNC" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vnc" /f >nul 2>&1
echo OK!
echo.

:: RESULT
echo ========================================
echo            HASIL FINAL
echo ========================================
echo.
if not exist "C:\Program Files\RealVNC" (
    if not exist "C:\Program Files (x86)\RealVNC" (
        echo [✓] REALVNC UDAH ILANG TOTAL DARI PC LU!
        echo.
        echo Udah bersih bos, gaskeun lanjut aktivitas.
    ) else (
        echo [⚠️] Masih ada sisa dikit, cek manual ya
    )
) else (
    echo [⚠️] RealVNC masih ada, coba restart PC
)
echo.
pausepause
