@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Fix Explorer Policy Block (Safe Reset)

REM ============================
REM 1 = lakukan reset policy Explorer umum (disarankan)
REM 0 = cuma cek & backup aja
set DO_FIX=1
REM ============================

echo.
echo === [0] Backup registry policy Explorer (HKLM + HKCU) ===
set "BK=%USERPROFILE%\Desktop\RegBackup_ExplorerPolicy_%DATE:/=-%_%TIME::=-%"
set "BK=%BK: =%"
mkdir "%BK%" >nul 2>&1

reg export "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" "%BK%\HKLM_Policies_Explorer.reg" /y >nul 2>&1
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "%BK%\HKCU_Policies_Explorer.reg" /y >nul 2>&1

echo Backup disimpan di:
echo   "%BK%"
echo.

if "%DO_FIX%"=="0" (
  echo DO_FIX=0, jadi hanya backup. Selesai.
  goto :RESTART
)

echo === [1] Reset value yang sering bikin Explorer ke-block ===
REM --- HKLM ---
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktop /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoActiveDesktopChanges /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewExplorer /t REG_DWORD /d 0 /f >nul 2>&1

REM --- HKCU (user-level) ---
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewExplorer /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFileMenu /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoFolderOptions /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoViewContextMenu /t REG_DWORD /d 0 /f >nul 2>&1

echo Done set ke 0 (default).
echo.

echo === [2] Refresh policy (gpupdate) ===
gpupdate /target:user /force >nul 2>&1
gpupdate /target:computer /force >nul 2>&1

:RESTART
echo.
echo === [3] Restart Explorer ===
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 2 /nobreak >nul
start "" explorer.exe

echo.
echo === [4] Test ===
echo - Coba tekan Win + E
echo - Coba Save As dari app
echo.
echo Kalau masih error, kirim screenshot isi:
echo HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
echo (bagian kanan/value list)
echo.
pause
exit /b