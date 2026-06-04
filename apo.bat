@echo off
title GPU Freeze Fix - Fix By Suprix
echo ==========================================
echo   GPU JEMBUT NGENTOT AYAM BAKAR MADU MEME
echo ==========================================
echo.

:: Deteksi Windows version
echo [*] Detecting Windows version...
ver
echo.

:: Matiin hardware acceleration via registry
echo [*] Disabling hardware acceleration in registry...

reg add "HKLM\SOFTWARE\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Avalon.Graphics" /v DisableHWAcceleration /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v EnableAeroPeek /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v Animations /t REG_DWORD /d 0 /f

:: Disable transparency effects
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f

:: Matiin visual effects
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012038010000000 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_STRING /d 0 /f

:: Set performance options
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f

:: Disable GPU scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f

echo [+] Registry entries added
echo.

:: Cek dan patch config StarDesk
if exist "%APPDATA%\StarDesk\config.json" (
    echo [*] Found StarDesk config, patching...
    powershell -Command "$c = Get-Content '%APPDATA%\StarDesk\config.json' -Raw | ConvertFrom-Json; $c.hardwareAcceleration = $false; $c.GPUEncoding = $false; $c.EnableSoftwareRendering = $true; $c | ConvertTo-Json | Set-Content '%APPDATA%\StarDesk\config.json'"
    echo [+] StarDesk config patched
) else (
    echo [!] StarDesk config not found, skip patching
)

:: Cek Avica
if exist "C:\Program Files\Avica\avica.exe" (
    echo [*] Found Avica, creating safe shortcut...
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\Avica Safe Mode.lnk'); $s.TargetPath = 'C:\Program Files\Avica\avica.exe'; $s.Arguments = '--disable-gpu --disable-software-rasterizer --no-sandbox --disable-direct-composition'; $s.Save()"
    echo [+] Avica safe shortcut created on desktop
)

:: Cek StarDesk shortcut
if exist "C:\Program Files\StarDesk\stardesk.exe" (
    echo [*] Found StarDesk, creating safe shortcut...
    powershell -Command "$ws = New-Object -ComObject WScript.Shell; $s = $ws.CreateShortcut('%USERPROFILE%\Desktop\StarDesk Safe Mode.lnk'); $s.TargetPath = 'C:\Program Files\StarDesk\stardesk.exe'; $s.Arguments = '--disable-gpu --disable-software-rasterizer --no-sandbox --disable-direct-composition'; $s.Save()"
    echo [+] StarDesk safe shortcut created on desktop
)

:: Set environment variables permanently
echo [*] Setting environment variables...
setx DISABLE_GPU "1" /M
setx DISABLE_HW_ACCELERATION "1" /M
setx QT_QUICK_BACKEND "software" /M

:: Kill problematic services
echo [*] Killing problematic services...
sc stop "UsoSvc" >nul 2>&1
sc config "UsoSvc" start=disabled >nul 2>&1

:: Clean temp files
echo [*] Cleaning temp files...
del /f /q "%TEMP%\*" >nul 2>&1
del /f /q "C:\Windows\Temp\*" >nul 2>&1

echo.
echo ==========================================
echo   DONE BRO! 
echo ==========================================
echo.
echo Settings udah di-apply, wajib restart VM lo sekarang
echo Ketik "shutdown /r /t 10" buat restart dalam 10 detik
echo.
echo Kalo setelah restart masih freeze, run script ini lagi dan coba
echo buka remote app pake shortcut Safe Mode yang ada di desktop
echo.

pause
shutdown /r /t 30
