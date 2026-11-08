
@echo off
title AUTO PUSH GITHUB - POWER BI ASSETS
color 0B

cd /d "%~dp0"

echo.
echo ==========================================
echo       AUTO PUSH GITHUB - POWER BI
echo ==========================================

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
    echo ERROR: Folder bukan Git Repository.
    pause
    exit /b 1
)

for /f "delims=" %%B in ('git branch --show-current') do set BRANCH=%%B

echo.
echo [1/3] Memeriksa perubahan file...
git add -A

git diff --cached --quiet

if errorlevel 1 (
    echo.
    echo [2/3] Membuat commit...
    git commit -m "Update Power BI Assets"
    if errorlevel 1 (
        echo ERROR: Commit gagal.
        pause
        exit /b 1
    )
) else (
    echo Tidak ada perubahan baru.
    echo Melanjutkan push commit yang sudah ada...
)

echo.
echo [3/3] Mengirim file ke GitHub...

git push -u origin "%BRANCH%"

if errorlevel 1 (
    echo.
    echo ==========================================
    echo PUSH GAGAL - PERIKSA AKSES GITHUB
    echo ==========================================
    pause
    exit /b 1
)

echo.
echo ==========================================
echo          PUSH BERHASIL!
echo ==========================================
echo Repository berhasil diperbarui.
echo.
pause
