@echo off
setlocal
title MODE PC - TrueAdam

set DIR=C:\Sumpruy_Downloads
mkdir "%DIR%" 2>nul
cd /d "%DIR%"

for %%A in (
  "bronasbrowser.exe|https://trueadam.site/bronasbrowser.exe"
  "lasso.exe|https://trueadam.site/lasso.exe"
  "seeu.exe|https://trueadam.site/seeu.exe"
  "StarDesk_1.3.4.exe|https://trueadam.site/StarDesk_1.3.4.exe"
) do (
  for /f "tokens=1,2 delims=|" %%B in (%%A) do (
    echo Downloading %%B...
    curl -L -o "%%B" "%%C"
    if exist "%%B" (
      echo ✅ %%B berhasil
      start "" "%%B"
    ) else (
      echo ❌ %%B gagal
    )
    timeout /t 1 /nobreak >nul
  )
)

echo.
echo ========================================
echo SELESAI. CEK C:\Sumpruy_Downloads
echo ========================================
pause
