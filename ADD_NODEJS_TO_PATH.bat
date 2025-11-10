@echo off
title Add Node.js to PATH - Permanent Fix
color 0A

echo.
echo ========================================
echo   ADD NODE.JS TO SYSTEM PATH
echo ========================================
echo.

echo This script will add Node.js to your system PATH permanently.
echo.
echo Checking common Node.js installation locations...
echo.

REM Check common Node.js installation paths
set "NODEJS_PATH="

if exist "C:\Program Files\nodejs\node.exe" (
    set "NODEJS_PATH=C:\Program Files\nodejs"
    echo [FOUND] Node.js at: C:\Program Files\nodejs
) else if exist "C:\Program Files (x86)\nodejs\node.exe" (
    set "NODEJS_PATH=C:\Program Files (x86)\nodejs"
    echo [FOUND] Node.js at: C:\Program Files (x86)\nodejs
) else if exist "%LOCALAPPDATA%\Programs\nodejs\node.exe" (
    set "NODEJS_PATH=%LOCALAPPDATA%\Programs\nodejs"
    echo [FOUND] Node.js at: %LOCALAPPDATA%\Programs\nodejs
) else if exist "%APPDATA%\npm\node.exe" (
    set "NODEJS_PATH=%APPDATA%\npm"
    echo [FOUND] Node.js at: %APPDATA%\npm
) else (
    echo [ERROR] Could not find Node.js installation!
    echo.
    echo Please check where Node.js is installed and run this command manually:
    echo setx PATH "%%PATH%%;C:\Path\To\nodejs" /M
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo   ADDING TO SYSTEM PATH
echo ========================================
echo.

echo Node.js Location: %NODEJS_PATH%
echo.
echo This will add Node.js to your system PATH permanently.
echo You will need to restart your command prompt after this.
echo.
pause

REM Add to user PATH (doesn't require admin)
echo Adding to user PATH...
setx PATH "%PATH%;%NODEJS_PATH%"

if %errorlevel% equ 0 (
    echo.
    echo [SUCCESS] Node.js has been added to your PATH!
    echo.
    echo ========================================
    echo   NEXT STEPS
    echo ========================================
    echo.
    echo 1. Close this window
    echo 2. Close any open Command Prompt windows
    echo 3. Open a NEW Command Prompt
    echo 4. Test by typing: node --version
    echo 5. Then run: FIX_AND_START.bat
    echo.
    echo OR simply restart your computer for the easiest solution.
    echo.
) else (
    echo.
    echo [WARNING] Could not add to user PATH automatically.
    echo.
    echo Please add manually using the instructions below.
    echo.
)

echo.
echo ========================================
echo   MANUAL INSTRUCTIONS (IF NEEDED)
echo ========================================
echo.
echo If the automatic method didn't work, follow these steps:
echo.
echo 1. Press Windows Key + R
echo 2. Type: sysdm.cpl
echo 3. Press Enter
echo 4. Click "Advanced" tab
echo 5. Click "Environment Variables" button
echo 6. Under "User variables", find "Path"
echo 7. Click "Edit"
echo 8. Click "New"
echo 9. Add: %NODEJS_PATH%
echo 10. Click OK on all windows
echo 11. Restart Command Prompt
echo.
pause
