@echo off
title Gajanan Canteen - Complete System Startup
color 0A

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║        🍽️  GAJANAN CANTEEN MANAGEMENT SYSTEM 🍽️          ║
echo ║                                                            ║
echo ║              Complete System Startup                       ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo Starting all servers...
echo.

REM Get local IP address
echo [1/5] 🌐 Detecting your IP address...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set IP=%%a
    goto :found_ip
)
:found_ip
set IP=%IP:~1%
echo ✅ Your IP: %IP%
echo.

REM Check if Node.js is installed
echo [2/5] 🔍 Checking Node.js installation...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Node.js is not installed!
    echo Please install Node.js from https://nodejs.org/
    pause
    exit /b 1
)
echo ✅ Node.js is installed
echo.

REM Check if Python is installed
echo [3/5] 🔍 Checking Python installation...
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ ERROR: Python is not installed!
    echo Please install Python from https://www.python.org/
    pause
    exit /b 1
)
echo ✅ Python is installed
echo.

REM Install backend dependencies if needed
echo [4/5] 📦 Checking backend dependencies...
cd backend
if not exist "node_modules" (
    echo Installing backend dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo ❌ ERROR: Failed to install dependencies
        pause
        exit /b 1
    )
)
echo ✅ Backend dependencies ready
cd ..
echo.

REM Configure Windows Firewall
echo [5/5] 🔥 Configuring Windows Firewall...
echo.
echo ⚠️  IMPORTANT: You may see firewall prompts
echo     Please click "Allow access" for:
echo     - Python
echo     - Node.js
echo.
echo If you don't see prompts, the firewall rules may already exist.
echo.
timeout /t 3 >nul

REM Kill any existing processes on our ports
echo Stopping any existing servers...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do taskkill /F /PID %%a >nul 2>&1
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3001') do taskkill /F /PID %%a >nul 2>&1
echo.

echo ╔════════════════════════════════════════════════════════════╗
echo ║                  STARTING SERVERS...                       ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Start Backend Image Server (Port 3000)
echo [Server 1/3] 🖼️  Starting Backend Image Server (Port 3000)...
start "Backend Image Server" cmd /k "cd backend && node localStorage-server.js"
timeout /t 2 >nul
echo ✅ Backend server started
echo.

REM Start Order Sync Server (Port 3001)
echo [Server 2/3] 🔄 Starting Order Sync Server (Port 3001)...
start "Order Sync Server" cmd /k "cd backend && node sync-server.js"
timeout /t 2 >nul
echo ✅ Sync server started
echo.

REM Start Frontend Server (Port 8080)
echo [Server 3/3] 🌐 Starting Frontend Server (Port 8080)...
start "Frontend Server" cmd /k "python -m http.server 8080 --bind 0.0.0.0"
timeout /t 3 >nul
echo ✅ Frontend server started
echo.

echo ╔════════════════════════════════════════════════════════════╗
echo ║                   ✅ ALL SERVERS RUNNING!                  ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo 📊 Server Status:
echo    ✅ Backend (Images):     http://localhost:3000
echo    ✅ Sync Server:          http://localhost:3001
echo    ✅ Frontend:             http://localhost:8080
echo.
echo 🌐 Access from Mobile/Tablet:
echo    📱 Customer App:         http://%IP%:8080/c3.html
echo    🖥️  Admin Portal:         http://%IP%:8080/admin_portal.html
echo    📋 QR Codes:             http://%IP%:8080/qr-codes.html
echo.
echo 💡 Tips:
echo    - Keep this window open
echo    - Mobile must be on same WiFi
echo    - Admin login: admin / admin123
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║              Opening Admin Portal in 5 seconds...          ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

timeout /t 5 >nul

REM Open admin portal
start http://localhost:8080/admin_portal.html

echo.
echo ✅ System is ready!
echo.
echo Press any key to view QR codes for printing...
pause >nul

REM Open QR codes page
start http://localhost:8080/qr-codes.html

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║     🎉 GAJANAN CANTEEN SYSTEM IS FULLY OPERATIONAL! 🎉    ║
echo ║                                                            ║
echo ║  All features enabled:                                     ║
echo ║  ✅ Mobile ordering via QR codes                          ║
echo ║  ✅ Real-time order sync (2-second updates)               ║
echo ║  ✅ Admin notifications                                   ║
echo ║  ✅ Table number tracking                                 ║
echo ║  ✅ Responsive design (mobile + desktop)                  ║
echo ║                                                            ║
echo ║  Keep this window open to keep servers running!           ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo Press any key to stop all servers and exit...
pause >nul

REM Stop all servers
echo.
echo Stopping all servers...
taskkill /F /FI "WINDOWTITLE eq Backend Image Server*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Order Sync Server*" >nul 2>&1
taskkill /F /FI "WINDOWTITLE eq Frontend Server*" >nul 2>&1

echo ✅ All servers stopped
echo.
echo Thank you for using Gajanan Canteen System!
timeout /t 3 >nul
