@echo off
echo REALVNC BERSIH-BERSIH MULAI BOSQUE 🗿🔥

:: KILL PROSES REALVNC
tasklist | find /i "vncserver.exe" >nul
if %errorlevel%==0 (
    taskkill /IM vncserver.exe /F >nul 2>&1
    echo vncserver.exe udah gue bunuh 😈
)

tasklist | find /i "winvnc.exe" >nul
if %errorlevel%==0 (
    taskkill /IM winvnc.exe /F >nul 2>&1
    echo winvnc.exe gue kill juga 😤
)

tasklist | find /i "vncviewer.exe" >nul
if %errorlevel%==0 (
    taskkill /IM vncviewer.exe /F >nul 2>&1
    echo vncviewer.exe ikut mati 😎
)

:: MATIKAN SERVICE REALVNC
net stop vncserver /y >nul 2>&1
sc stop vncserver /y >nul 2>&1
net stop "RealVNC Server" /y >nul 2>&1
sc stop "RealVNC Server" /y >nul 2>&1
echo Service RealVNC udah mati total 👊

:: HAPUS FILE REALVNC DI SEMUA LOKASI
del /f /q "C:\Program Files\RealVNC\VNC Server\vncserver.exe" 2>nul
del /f /q "C:\Program Files\RealVNC\VNC Server\winvnc.exe" 2>nul
del /f /q "C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe" 2>nul
del /f /q "C:\Program Files\RealVNC\*.*" 2>nul
del /f /q "%ProgramFiles%\RealVNC\VNC Server\*.*" 2>nul
del /f /q "%ProgramFiles%\RealVNC\VNC Viewer\*.*" 2>nul
del /f /q "%ProgramFiles%\RealVNC\*.*" 2>nul
echo File exe RealVNC udah ilang semua 😡

:: HAPUS FOLDER REALVNC
rmdir /s /q "C:\Program Files\RealVNC" 2>nul
rmdir /s /q "%ProgramFiles%\RealVNC" 2>nul
echo Folder RealVNC udah gue hapus pake rmdir /s /q 🤭

:: HAPUS REGISTRY REALVNC BIAR GA BISA AUTO START
reg delete "HKLM\SOFTWARE\RealVNC" /f >nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\RealVNC" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\vncserver" /f >nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\RealVNC Server" /f >nul 2>&1
reg delete "HKCU\SOFTWARE\RealVNC" /f >nul 2>&1
echo Registry RealVNC udah dihapus total ga bakal jalan lagi 😜

:: HAPUS CONFIG DAN DATA VNC
del /f /q "%PROGRAMDATA%\RealVNC\*.*" 2>nul
rmdir /s /q "%PROGRAMDATA%\RealVNC" 2>nul
del /f /q "%USERPROFILE%\AppData\Roaming\RealVNC\*.*" 2>nul
rmdir /s /q "%USERPROFILE%\AppData\Roaming\RealVNC" 2>nul
echo Semua config dan data RealVNC udah ilang 😱

echo SEMUA BERES BOSQUE! REALVNC ILANG TANPA JEJAK TOTAL! 🗿🔥
pause
