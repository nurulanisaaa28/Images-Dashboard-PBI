
@echo off
title AUTO PUSH GITHUB - POWER BI ASSETS
color 0B

echo.
echo ==========================================
echo       AUTO PUSH GITHUB - POWER BI
echo ==========================================
echo.

:: Masuk ke folder tempat BAT berada
cd /d "%~dp0"

:: Cek apakah folder merupakan Git Repository
git rev-parse --is-inside-work-tree >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Folder ini belum terhubung ke Git.
    echo Silakan setup repository terlebih dahulu.
    pause
    exit /b 1
)

:: Ambil nama branch aktif
for /f "delims=" %%B in ('git branch --show-current') do set BRANCH=%%B

if "%BRANCH%"=="" (
    echo [ERROR] Tidak dapat mendeteksi branch aktif.
    pause
    exit /b 1
)

:: Cek remote GitHub
git remote get-url origin >nul 2>&1

if errorlevel 1 (
    echo [ERROR] Remote origin belum dikonfigurasi.
    pause
    exit /b 1
)

echo [1/3] Memeriksa perubahan file...
git add -A

:: Cek apakah ada perubahan
git diff --cached --quiet

if not errorlevel 1 (
    echo.
    echo [INFO] Tidak ada file baru atau perubahan.
    echo Semua file sudah tersinkronisasi.
    pause
    exit /b 0
)

echo.
echo [2/3] Membuat commit...
git commit -m "Update Power BI Assets - %date% %time%"

if errorlevel 1 (
    echo [ERROR] Commit gagal.
    pause
    exit /b 1
)

echo.
echo [3/3] Mengirim file ke GitHub...
git push -u origin "%BRANCH%"

if errorlevel 1 (
    echo.
    echo [ERROR] Push gagal. Periksa koneksi atau autentikasi GitHub.
    pause
    exit /b 1
)

echo.
echo ==========================================
echo          PUSH BERHASIL!
echo ==========================================
echo Semua perubahan berhasil dikirim ke GitHub.
echo.
pause
