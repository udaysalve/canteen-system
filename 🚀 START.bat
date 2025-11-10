@echo off
title Canteen System Startup
color 0A

echo.
echo ════════════════════════════════════════════════════════════════
echo          🏪 SHREE GAJANAN CANTEEN - STARTING SYSTEM 🏪
echo ════════════════════════════════════════════════════════════════
echo.

REM Get the directory where this script is located
cd /d "%~dp0"

REM Check Node.js
echo [1/3] Checking Node.js...
where node >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js not found!
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)
echo ✅ Node.js found

REM Install backend dependencies if needed
echo [2/3] Checking backend dependencies...
cd backend
if not exist "node_modules" (
    echo Installing dependencies...
    call npm install
)
echo ✅ Dependencies ready

REM Start backend
echo [3/3] Starting servers...
echo.
start "Backend Server (Port 3000)" cmd /k "node server.js"
timeout /t 2 /nobreak >nul

REM Start frontend with Node.js http-server
cd ..
start "Frontend Server (Port 8080)" cmd /k "npx http-server -p 8080 -c-1"
timeout /t 3 /nobreak >nul

echo.
echo ════════════════════════════════════════════════════════════════
echo ✅ SYSTEM STARTED!
echo ════════════════════════════════════════════════════════════════
echo.
echo 📱 User Portal:  http://localhost:8080/c3.html
echo 🔧 Admin Portal: http://localhost:8080/admin.html
echo.
echo 🔑 Admin Login: admin / admin123
echo.
echo ⚠️  Keep the server windows open!
echo ════════════════════════════════════════════════════════════════
echo.

REM Open browser
echo Opening browser...
timeout /t 2 /nobreak >nul
start http://localhost:8080/c3.html

echo.
echo ✅ Done! System is running.
echo.
echo To stop: Close the server windows or run STOP_ALL.bat
echo.
pause
