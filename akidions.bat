@echo off
title FIX STARDESK + CLOUD GAMING NO FREEZE ANJAY
color 0E
echo ============================================
echo    STARDESK + CLOUD GAMING JALAN BARENG
echo    ANTI FREEZE ANTI CRASH GASS
echo ============================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ADMIN ANJG! JALANIN PAKE ADMINISTRATOR!
    pause
    exit
)

echo [1/8] Setting Stardesk pake software rendering biar ga konflik GPU...
reg add "HKLM\SOFTWARE\Stardesk" /v "RenderMode" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Stardesk" /v "HardwareAcceleration" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Stardesk" /v "UseGPU" /t REG_DWORD /d 0 /f >nul 2>&1
echo DONE! Stardesk dipaksa pake CPU bukan GPU

echo.
echo [2/8] Disable virtual display adapter Stardesk...
pnputil /enum-drivers | findstr /i "stardesk" > temp_driver.txt
for /f "tokens=*" %%a in (temp_driver.txt) do (
    pnputil /disable-device "%%a" >nul 2>&1
)
del temp_driver.txt >nul 2>&1
devcon disable =Display "Stardesk*" >nul 2>&1
devcon disable =Display "*Mirror*" >nul 2>&1
echo DONE! Virtual display Stardesk dimatiin

echo.
echo [3/8] Bikin exception GPU buat cloud gaming...
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul
echo DONE! Cloud gaming dapet prioritas GPU tertinggi

echo.
echo [4/8] Limit FPS Stardesk biar ga nyedot resource...
reg add "HKCU\SOFTWARE\Stardesk" /v "MaxFPS" /t REG_DWORD /d 15 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Stardesk" /v "QualityMode" /t REG_DWORD /d 1 /f >nul 2>&1
echo DONE! Stardesk dibatasin 15 FPS aja cukup buat remote

echo.
echo [5/8] Set affinity Stardesk ke CPU thread rendah...
powershell -Command "$p = Get-Process -Name 'stardesk', 'strwinclt' -ErrorAction SilentlyContinue; foreach($proc in $p) { $proc.ProcessorAffinity = 0x000F }" >nul 2>&1
echo DONE! Stardesk cuma pake 4 core awal

echo.
echo [6/8] Matiin hardware acceleration di browser cloud gaming...
reg add "HKLM\SOFTWARE\Policies\Google\Chrome" /v "HardwareAccelerationModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "HardwareAccelerationModeEnabled" /t REG_DWORD /d 0 /f >nul 2>&1
echo DONE!

echo.
echo [7/8] Fix registry GPU timeout...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 60 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDdiDelay /t REG_DWORD /d 60 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrLevel /t REG_DWORD /d 0 /f >nul
echo DONE! GPU timeout dimatiin total

echo.
echo [8/8] Bikin watchdog auto recover kalo mulai freeze...
powershell -WindowStyle Hidden -Command "
Add-Type -MemberDefinition '[DllImport(\"user32.dll\")]public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);' -Name 'kb' -Namespace 'Win32';
while(\$true) {
    \$gpuCounter = (Get-Counter '\GPU Engine(*engtype_3D)\Utilization Percentage' -ErrorAction SilentlyContinue).CounterSamples | Where-Object { \$_.CookedValue -gt 0 }
    if(-\$gpuCounter) {
        \$time = Get-Date -Format 'HH:mm:ss'
        Add-Content \$env:TEMP\gpu_watchdog.txt \"\$time - GPU idle, resetting...\"
        [Win32.kb]::keybd_event(0x5B,0,0,[UIntPtr]::Zero); Start-Sleep -Milliseconds 30;
        [Win32.kb]::keybd_event(0x11,0,0,[UIntPtr]::Zero); Start-Sleep -Milliseconds 30;
        [Win32.kb]::keybd_event(0x10,0,0,[UIntPtr]::Zero); Start-Sleep -Milliseconds 30;
        [Win32.kb]::keybd_event(0x42,0,0,[UIntPtr]::Zero); Start-Sleep -Milliseconds 30;
        [Win32.kb]::keybd_event(0x42,0,2,[UIntPtr]::Zero); Start-Sleep -Milliseconds 30;
        [Win32.kb]::keybd_event(0x10,0,2,[UIntPtr]::Zero); Start-Sleep -Milliseconds 30;
        [Win32.kb]::keybd_event(0x11,0,2,[UIntPtr]::Zero); Start-Sleep -Milliseconds 30;
        [Win32.kb]::keybd_event(0x5B,0,2,[UIntPtr]::Zero);
    }
    Start-Sleep -Seconds 15
}" >nul 2>&1
echo DONE! Watchdog jalan di background

echo.
echo ============================================
echo    BERES ANJG! STARDESK + CLOUD GAMING AMAN
echo ============================================
echo.
echo Yang udah dilakuin:
echo - Stardesk dipaksa software rendering (CPU)
echo - Virtual display dimatiin
echo - Cloud gaming dapet prioritas GPU
echo - Stardesk dibatasin 15 FPS
echo - GPU timeout dimatiin
echo - Watchdog auto-reset jalan di background
echo.
echo JANGAN LUPA RESTART PC BIAR EFEK MAXIMAL!
echo.
pause
