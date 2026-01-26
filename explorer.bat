@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Fix Cairo Desktop (Full) + Log

REM =========================
REM 1 = reset config Cairo (recommended)
REM 0 = jangan reset
set RESET=1
REM =========================

set "LOG=%~dp0FixCairo_Log.txt"
echo ==== Fix Cairo Full Run (%date% %time%) ==== > "%LOG%"

echo.
echo [0] Log file: "%LOG%"

REM --- Admin check
net session >nul 2>&1
if not "%errorlevel%"=="0" (
  echo [!] Not running as admin. >> "%LOG%"
  echo ERROR: Run as Administrator dulu.
  pause
  exit /b 1
)
echo [OK] Admin mode. >> "%LOG%"

REM --- Kill Cairo if stuck
echo.
echo [1/9] Menutup CairoDesktop jika sedang berjalan...
echo [1] taskkill CairoDesktop.exe >> "%LOG%"
taskkill /f /im CairoDesktop.exe >> "%LOG%" 2>&1

REM --- Restart Explorer
echo.
echo [2/9] Restart Windows Explorer...
echo [2] taskkill explorer.exe >> "%LOG%"
taskkill /f /im explorer.exe >> "%LOG%" 2>&1
timeout /t 2 /nobreak >nul
echo [2] start explorer.exe >> "%LOG%"
start "" explorer.exe
timeout /t 3 /nobreak >nul

REM --- Quick check: Explorer can open a folder?
echo.
echo [3/9] Test Explorer buka folder user...
echo [3] explorer "%USERPROFILE%" >> "%LOG%"
start "" explorer.exe "%USERPROFILE%" >> "%LOG%" 2>&1
timeout /t 2 /nobreak >nul

REM --- Reset Cairo config (fix panel off-screen / corrupted config)
if "%RESET%"=="1" (
  echo.
  echo [4/9] Reset konfigurasi Cairo (LOCALAPPDATA)...
  echo [4] rmdir "%LOCALAPPDATA%\CairoDesktop" >> "%LOG%"
  if exist "%LOCALAPPDATA%\CairoDesktop" (
    rmdir /s /q "%LOCALAPPDATA%\CairoDesktop" >> "%LOG%" 2>&1
    echo     OK: Config Cairo dihapus: "%LOCALAPPDATA%\CairoDesktop"
  ) else (
    echo     Skip: Folder config tidak ada.
  )
) else (
  echo.
  echo [4/9] Skip reset config (RESET=0)
)

REM --- Check .NET Desktop Runtime presence (basic)
echo.
echo [5/9] Cek .NET Desktop Runtime (basic check)...
set "DOTNETOK=0"
if exist "%ProgramFiles%\dotnet\dotnet.exe" set "DOTNETOK=1"
if exist "%ProgramFiles(x86)%\dotnet\dotnet.exe" set "DOTNETOK=1"
echo [5] dotnet present = %DOTNETOK% >> "%LOG%"
if "%DOTNETOK%"=="0" (
  echo     Info: dotnet.exe tidak terdeteksi. Cairo bisa gagal launch kalau runtime belum ada.
  echo     (Ini catatan saja, script tetap lanjut.)
)

REM --- Find Cairo path (registry uninstall keys + common paths)
echo.
echo [6/9] Mencari CairoDesktop.exe dari registry + lokasi umum...

set "CAIRO_EXE="
call :FIND_FROM_UNINSTALL
call :FIND_COMMON_PATHS
call :FIND_FROM_STARTMENU

echo [6] CAIRO_EXE resolved = "%CAIRO_EXE%" >> "%LOG%"

REM --- Try launch Cairo
echo.
echo [7/9] Menjalankan Cairo...
if not defined CAIRO_EXE (
  echo     CairoDesktop.exe belum ketemu otomatis.
  echo     Coba cari manual file "CairoDesktop.exe" di drive C: lalu jalankan.
  echo     Log: "%LOG%"
  goto :END
)

echo     Ketemu: "%CAIRO_EXE%"
echo [7] start Cairo "%CAIRO_EXE%" >> "%LOG%"
start "" "%CAIRO_EXE%" >> "%LOG%" 2>&1
timeout /t 5 /nobreak >nul

REM --- Verify Cairo process running
echo.
echo [8/9] Verifikasi Cairo berjalan...
tasklist /fi "imagename eq CairoDesktop.exe" | find /i "CairoDesktop.exe" >nul
if "%errorlevel%"=="0" (
  echo     OK: CairoDesktop.exe running.
  echo [8] Cairo running. >> "%LOG%"
) else (
  echo     Cairo tidak terlihat berjalan (mungkin crash / diblok).
  echo [8] Cairo NOT running after start. >> "%LOG%"
  echo.
  echo Coba buka log untuk lihat error.
)

REM --- Helpful notes
echo.
echo [9/9] Tips kalau panel masih tidak terlihat:
echo - Panel bisa "kabur" ke layar lain: coba ubah resolusi / scaling lalu buka lagi.
echo - Pastikan tidak ada aplikasi shell lain yang bentrok.
echo - Buka "%LOCALAPPDATA%\CairoDesktop" (kalau RESET=0) untuk cek config.
echo.
echo Selesai. Log: "%LOG%"
pause
exit /b 0

REM =========================
REM FUNCTIONS
REM =========================

:FIND_FROM_UNINSTALL
REM Try uninstall keys (DisplayIcon / InstallLocation)
for %%K in (
 "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
 "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
) do (
  for /f "tokens=*" %%S in ('reg query %%K 2^>nul ^| findstr /i /r "Cairo"') do (
    REM Try DisplayIcon first
    for /f "tokens=2,*" %%A in ('reg query "%%S" /v DisplayIcon 2^>nul ^| findstr /i "DisplayIcon"') do (
      call :CLEANPATH "%%B" CLEANED
      if exist "!CLEANED!" (
        set "CAIRO_EXE=!CLEANED!"
        echo [REG] Found via DisplayIcon: "!CLEANED!" >> "%LOG%"
        goto :EOF
      )
    )
    REM Try InstallLocation
    for /f "tokens=2,*" %%A in ('reg query "%%S" /v InstallLocation 2^>nul ^| findstr /i "InstallLocation"') do (
      set "IL=%%B"
      call :TRIMQUOTES IL
      if exist "!IL!\CairoDesktop.exe" (
        set "CAIRO_EXE=!IL!\CairoDesktop.exe"
        echo [REG] Found via InstallLocation: "!CAIRO_EXE!" >> "%LOG%"
        goto :EOF
      )
    )
  )
)
goto :EOF

:FIND_COMMON_PATHS
set "P1=%ProgramFiles%\Cairo Desktop\CairoDesktop.exe"
set "P2=%ProgramFiles(x86)%\Cairo Desktop\CairoDesktop.exe"
set "P3=%LocalAppData%\Programs\Cairo Desktop\CairoDesktop.exe"
set "P4=%UserProfile%\Downloads\CairoDesktop.exe"
set "P5=%UserProfile%\Desktop\CairoDesktop.exe"

for %%P in ("%P1%" "%P2%" "%P3%" "%P4%" "%P5%") do (
  if not defined CAIRO_EXE (
    if exist "%%~P" (
      set "CAIRO_EXE=%%~P"
      echo [PATH] Found common path: "%%~P" >> "%LOG%"
    )
  )
)
goto :EOF

:FIND_FROM_STARTMENU
REM Find a Start Menu shortcut and resolve by calling PowerShell to read .lnk target
if defined CAIRO_EXE goto :EOF

set "SM1=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
set "SM2=%AppData%\Microsoft\Windows\Start Menu\Programs"

for %%D in ("%SM1%" "%SM2%") do (
  if defined CAIRO_EXE goto :EOF
  for /f "delims=" %%L in ('dir /b /s "%%~D\*Cairo*.lnk" 2^>nul') do (
    if defined CAIRO_EXE goto :EOF
    echo [LNK] Found shortcut: "%%L" >> "%LOG%"
    for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command ^
      "$s=(New-Object -ComObject WScript.Shell).CreateShortcut('%%L'); $s.TargetPath" 2^>nul`) do (
      if exist "%%T" (
        set "CAIRO_EXE=%%T"
        echo [LNK] Resolved target: "%%T" >> "%LOG%"
        goto :EOF
      )
    )
  )
)
goto :EOF

:CLEANPATH
REM Remove ",0" or ",1" suffix from DisplayIcon and trim quotes
set "RAW=%~1"
set "RAW=%RAW:"=%"
for /f "tokens=1 delims=," %%X in ("%RAW%") do set "OUT=%%X"
set "%~2=%OUT%"
goto :EOF

:TRIMQUOTES
set "VAR=!%~1!"
set "VAR=%VAR:"=%"
set "%~1=%VAR%"
goto :EOF

:END
echo.
echo ----
echo Tidak berhasil menentukan path CairoDesktop.exe.
echo Buka "%LOG%" untuk detail.
pause
exit /b 1