@echo off
title AUTO GPU RESET BACKGROUND
color 0A
echo ============================================
echo    AUTO RESET GPU KALO FREEZE STREAMING
echo    JALAN DI BACKGROUND AMAN GA MATI PC
echo ============================================
echo.
echo Script jalan di background, close window ini kalo mau stop
echo.
powershell -WindowStyle Hidden -Command "
Add-Type -MemberDefinition '[DllImport(\"user32.dll\")]public static extern void keybd_event(byte bVk, byte bScan, uint dwFlags, UIntPtr dwExtraInfo);' -Name 'kb' -Namespace 'Win32';
while($true) {
    $processes = @('chrome', 'msedge', 'firefox', 'GeForceNOW', 'xbox', 'gamestream', 'Moonlight', 'Parsec', 'Stadia')
    $frozen = $false
    foreach($proc in $processes) {
        $p = Get-Process -Name $proc -ErrorAction SilentlyContinue
        if($p) {
            if($p.Responding -eq $false) {
                $frozen = $true
                break
            }
        }
    }
    $cpu = (Get-Counter '\GPU Engine(*engtype_3D)\Utilization Percentage' -ErrorAction SilentlyContinue).CounterSamples.CookedValue
    $gpuStuck = $false
    if($cpu -eq 0 -or $cpu -eq 100) {
        Start-Sleep -Seconds 5
        $cpu2 = (Get-Counter '\GPU Engine(*engtype_3D)\Utilization Percentage' -ErrorAction SilentlyContinue).CounterSamples.CookedValue
        if($cpu -eq $cpu2) {
            $gpuStuck = $true
        }
    }
    if($frozen -or $gpuStuck) {
        $time = Get-Date -Format 'HH:mm:ss'
        Add-Content -Path $env:TEMP\gpu_reset_log.txt -Value \"$time - GPU Freeze detected, resetting...\"
        [Win32.kb]::keybd_event(0x5B,0,0,[UIntPtr]::Zero)
        Start-Sleep -Milliseconds 50
        [Win32.kb]::keybd_event(0x11,0,0,[UIntPtr]::Zero)
        Start-Sleep -Milliseconds 50
        [Win32.kb]::keybd_event(0x10,0,0,[UIntPtr]::Zero)
        Start-Sleep -Milliseconds 50
        [Win32.kb]::keybd_event(0x42,0,0,[UIntPtr]::Zero)
        Start-Sleep -Milliseconds 50
        [Win32.kb]::keybd_event(0x42,0,2,[UIntPtr]::Zero)
        Start-Sleep -Milliseconds 50
        [Win32.kb]::keybd_event(0x10,0,2,[UIntPtr]::Zero)
        Start-Sleep -Milliseconds 50
        [Win32.kb]::keybd_event(0x11,0,2,[UIntPtr]::Zero)
        Start-Sleep -Milliseconds 50
        [Win32.kb]::keybd_event(0x5B,0,2,[UIntPtr]::Zero)
        Start-Sleep -Seconds 3
    }
    Start-Sleep -Seconds 10
}"
