@echo off
title System Diagnostics
color 0E

echo.
echo ════════════════════════════════════════════════════════════════
echo                    🔍 SYSTEM DIAGNOSTICS 🔍
echo ════════════════════════════════════════════════════════════════
echo.

cd /d "%~dp0"

echo [1] Checking Node.js installation...
echo.
node --version 2>nul
if errorlevel 1 (
    echo ❌ Node.js NOT FOUND
    echo    Please install from: https://nodejs.org/
    set NODE_OK=0
) else (
    echo ✅ Node.js is installed
    set NODE_OK=1
)
echo.

echo [2] Checking npm...
echo.
npm --version 2>nul
if errorlevel 1 (
    echo ❌ npm NOT FOUND
    set NPM_OK=0
) else (
    echo ✅ npm is installed
    set NPM_OK=1
)
echo.

echo [3] Checking backend folder...
echo.
if exist "backend" (
    echo ✅ backend folder exists
    cd backend
    if exist "simple-server.js" (
        echo ✅ simple-server.js found
    ) else (
        echo ❌ simple-server.js NOT FOUND
    )
    if exist "server.js" (
        echo ✅ server.js found
    ) else (
        echo ❌ server.js NOT FOUND
    )
    cd ..
) else (
    echo ❌ backend folder NOT FOUND
)
echo.

echo [4] Checking frontend files...
echo.
if exist "c3.html" (
    echo ✅ c3.html found
) else (
    echo ❌ c3.html NOT FOUND
)
if exist "admin.html" (
    echo ✅ admin.html found
) else (
    echo ❌ admin.html NOT FOUND
)
echo.

echo [5] Checking if ports are in use...
echo.
netstat -ano | findstr ":3000" >nul
if errorlevel 1 (
    echo ✅ Port 3000 is FREE
) else (
    echo ⚠️  Port 3000 is IN USE
    echo    Run STOP_ALL.bat to free it
)

netstat -ano | findstr ":8080" >nul
if errorlevel 1 (
    echo ✅ Port 8080 is FREE
) else (
    echo ⚠️  Port 8080 is IN USE
    echo    Run STOP_ALL.bat to free it
)
echo.

echo [6] Testing Node.js with simple server...
echo.
cd backend
echo Starting test server for 3 seconds...
start /min cmd /c "node simple-server.js"
timeout /t 3 /nobreak >nul
taskkill /F /IM node.exe >nul 2>&1
echo ✅ Test completed
cd ..
echo.

echo ════════════════════════════════════════════════════════════════
echo                        DIAGNOSIS COMPLETE
echo ════════════════════════════════════════════════════════════════
echo.

if %NODE_OK%==0 (
    echo ❌ ISSUE FOUND: Node.js not installed
    echo    Solution: Install from https://nodejs.org/
    echo.
)

if %NPM_OK%==0 (
    echo ❌ ISSUE FOUND: npm not available
    echo    Solution: Reinstall Node.js
    echo.
)

echo ════════════════════════════════════════════════════════════════
echo.
echo 💡 RECOMMENDED NEXT STEPS:
echo.
echo 1. If Node.js is missing: Install from https://nodejs.org/
echo 2. If ports are in use: Run STOP_ALL.bat
echo 3. To start system: Run "⚡ SIMPLE START.bat"
echo.
echo ════════════════════════════════════════════════════════════════
echo.
pause
