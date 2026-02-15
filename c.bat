@echo off
title VNC Cleanup - RealVNC Uninstaller
color 0C
echo ========================================
echo    MENGHAPUS REALVNC DARI PROGRAM FILES
echo ========================================
echo.

:: Kill semua proses VNC
echo [!] Menghentikan proses VNC...
taskkill /f /im vncserver.exe 2>nul
taskkill /f /im winvnc.exe 2>nul
taskkill /f /im vncservice.exe 2>nul
taskkill /f /im vncserverui.exe 2>nul
taskkill /f /im tvnserver.exe 2>nul
taskkill /f /im uvnc_service.exe 2>nul

:: Kill juga proses RealVNC spesifik
taskkill /f /im vncserver4.exe 2>nul
taskkill /f /im vncconfig.exe 2>nul
taskkill /f /im vncpasswd.exe 2>nul

echo [✓] Proses VNC dihentikan
echo.
timeout /t 2 /nobreak >nul

:: Hapus folder RealVNC dari Program Files
echo [!] Menghapus folder RealVNC dari C:\Program Files...

if exist "C:\Program Files\RealVNC" (
    echo [DITEMUKAN] Folder RealVNC ditemukan!
    
    :: Hapus isi folder paksa
    takeown /f "C:\Program Files\RealVNC" /r /d y 2>nul
    icacls "C:\Program Files\RealVNC" /grant administrators:F /t 2>nul
    
    :: Hapus folder
    rmdir /s /q "C:\Program Files\RealVNC" 2>nul
    
    if not exist "C:\Program Files\RealVNC" (
        echo [✓] Folder RealVNC berhasil dihapus!
    ) else (
        echo [✗] Gagal menghapus folder, coba cara kedua...
        
        :: Cara paksa pake del
        del /f /s /q "C:\Program Files\RealVNC\*.*" 2>nul
        rmdir /s /q "C:\Program Files\RealVNC" 2>nul
        
        if not exist "C:\Program Files\RealVNC" (
            echo [✓] Folder RealVNC berhasil dihapus!
        )
    )
) else (
    echo [✗] Folder RealVNC tidak ditemukan di C:\Program Files
)

:: Cek juga di Program Files (x86) buat jaga-jaga
echo.
echo [!] Cek juga di C:\Program Files (x86)...

if exist "C:\Program Files (x86)\RealVNC" (
    echo [DITEMUKAN] Folder RealVNC ditemukan di Program Files (x86)!
    rmdir /s /q "C:\Program Files (x86)\RealVNC" 2>nul
    echo [✓] Folder di Program Files (x86) dihapus
)

:: Hapus juga di AppData (settingan user)
echo.
echo [!] Bersihin juga sisa-sisa di AppData...

if exist "%ProgramData%\RealVNC" (
    rmdir /s /q "%ProgramData%\RealVNC" 2>nul
    echo [✓] Folder ProgramData\RealVNC dihapus
)

if exist "%AppData%\RealVNC" (
    rmdir /s /q "%AppData%\RealVNC" 2>nul
    echo [✓] Folder AppData\RealVNC dihapus
)

if exist "%LocalAppData%\RealVNC" (
    rmdir /s /q "%LocalAppData%\RealVNC" 2>nul
    echo [✓] Folder LocalAppData\RealVNC dihapus
)

:: Bersihin registry (optional - comment kalo ga mau)
echo.
echo [!] Membersihkan registry entries...
reg delete "HKLM\SOFTWARE\RealVNC" /f 2>nul
reg delete "HKCU\SOFTWARE\RealVNC" /f 2>nul
reg delete "HKLM\SOFTWARE\WOW6432Node\RealVNC" /f 2>nul

echo.
echo ========================================
echo    CLEANUP COMPLETE!
echo ========================================
echo.
echo RealVNC telah dihapus dari:
echo - C:\Program Files\RealVNC
echo - C:\Program Files (x86)\RealVNC (kalo ada)
echo - AppData folders
echo - Registry entries
echo.
echo [✓] PC udah bersih dari RealVNC!
echo.
pause
