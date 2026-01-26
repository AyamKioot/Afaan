@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Restore Windows UI (Explorer/Policy) - tanpa mematikan program lain

REM =============== Opsi ===============
REM 1 = reset policy Explorer yang umum ngeblok
REM 0 = cuma backup
set DO_FIX=1

REM 1 = restart Explorer di akhir
REM 0 = jangan restart Explorer
set RESTART_EXPLORER=1
REM ====================================

echo.
echo [0] Backup registry policy (HKLM/HKCU)...
set "BK=%USERPROFILE%\Desktop\WinPolicyBackup_%DATE:/=-%_%TIME::=-%"
set "BK=%BK: =%"
mkdir "%BK%" >nul 2>&1

reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "%BK%\HKLM_Policies_Explorer.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "%BK%\HKCU_Policies_Explorer.reg" /y >nul 2>&1
reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"   "%BK%\HKLM_Policies_System.reg"   /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"   "%BK%\HKCU_Policies_System.reg"   /y >nul 2>&1

echo Backup disimpan di:
echo   "%BK%"
echo.

if "%DO_FIX%"=="0" (
  echo DO_FIX=0, hanya backup. Selesai.
  goto :END
)

echo [1] Reset policy Explorer umum (set ke default = 0)...
REM ---- HKLM Explorer policies ----
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktop         /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktopChanges /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewExplorer         /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFolderOptions        /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFileMenu             /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewContextMenu      /t REG_DWORD /d 0 /f >nul 2>&1

REM ---- HKCU Explorer policies ----
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewExplorer         /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFolderOptions        /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFileMenu             /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewContextMenu      /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRun                  /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoControlPanel         /t REG_DWORD /d 0 /f >nul 2>&1

echo [2] Reset policy System yang kadang ngeblok UI...
REM ---- System policies (jangan ekstrem, cuma yang umum) ----
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableTaskMgr /t REG_DWORD /d 0 /f >nul 2>&1

echo [3] Refresh policy (gpupdate)...
gpupdate /target:user /force >nul 2>&1
gpupdate /target:computer /force >nul 2>&1

if "%RESTART_EXPLORER%"=="1" (
  echo [4] Restart Explorer...
  taskkill /f /im explorer.exe >nul 2>&1
  timeout /t 2 /nobreak >nul
  start "" explorer.exe
)

echo.
echo [5] Test:
echo - Tekan Win+E (Explorer)
echo - Coba "Save As" dari aplikasi
echo.
echo Catatan:
echo Kalau dycgserver memang terus menerapkan restriction, setting bisa balik lagi.
echo Solusi permanen: matikan fitur "lock/restrict explorer" dari setting dycg.
echo.
pause
exit /b 0

:END
pause
exit /b 0