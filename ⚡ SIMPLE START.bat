@echo off
title Canteen System - Simple Start
color 0A

echo.
echo ════════════════════════════════════════════════════════════════
echo          🏪 CANTEEN SYSTEM - SIMPLE STARTUP 🏪
echo ════════════════════════════════════════════════════════════════
echo.

cd /d "%~dp0"

REM Check Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js not found! Please install from: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js found
echo.
echo Starting servers...
echo.

REM Start simple backend
cd backend
start "Backend (Port 3000)" cmd /k "node simple-server.js"
timeout /t 2 /nobreak >nul

REM Start frontend
cd ..
start "Frontend (Port 8080)" cmd /k "npx http-server -p 8080 -c-1 --silent"
timeout /t 3 /nobreak >nul

echo ════════════════════════════════════════════════════════════════
echo ✅ SERVERS STARTED!
echo ════════════════════════════════════════════════════════════════
echo.
echo 📱 User Portal:  http://localhost:8080/c3.html
echo 🔧 Admin Portal: http://localhost:8080/admin.html
echo.
echo 🔑 Admin: admin / admin123
echo ════════════════════════════════════════════════════════════════
echo.

timeout /t 2 /nobreak >nul
start http://localhost:8080/c3.html

echo ✅ Browser opened! System ready.
echo.
pause
