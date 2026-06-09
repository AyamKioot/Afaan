@echo off
title Tes Arcade Downloader
set "URL=https://picteon.dev/files/Arcade.exe"
set "OUTFILE=Arcade.exe"

echo Downloading Arcade.exe dari picteon...
curl -L -o "%OUTFILE%" "%URL%" --silent --show-error

if exist "%OUTFILE%" (
    echo ✅ Download sukses! File: %OUTFILE%
    echo Ukuran file: %~zOUTFILE% bytes
    echo.
    echo Mencoba buka pake start...
    start "" "%OUTFILE%"
    echo.
    echo Kalau gak kebuka, coba manual double click.
) else (
    echo ❌ Gagal download. Cek koneksi atau link.
)

pause
