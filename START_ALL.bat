@echo off
title Shree Gajanan Canteen - Complete System Startup
color 0A

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                                                                ║
echo ║        🏪 SHREE GAJANAN CANTEEN MANAGEMENT SYSTEM 🏪          ║
echo ║                                                                ║
echo ║                    COMPLETE SYSTEM STARTUP                     ║
echo ║                                                                ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Starting all services...
echo.

REM Check if Node.js is installed
echo [1/4] Checking Node.js...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Node.js not found!
    echo.
    echo Please install Node.js from: https://nodejs.org/
    echo Or run: ADD_NODEJS_TO_PATH.bat if already installed
    pause
    exit /b 1
)
echo ✅ Node.js found

REM Check if npm is available
echo [2/4] Checking npm...
npm --version >nul 2>&1
if errorlevel 1 (
    echo ❌ npm not found!
    pause
    exit /b 1
)
echo ✅ npm found

REM Install backend dependencies if needed
echo [3/4] Checking backend dependencies...
cd /d "%~dp0backend"
if not exist "node_modules" (
    echo Installing backend dependencies...
    call npm install
    if errorlevel 1 (
        echo ❌ Failed to install backend dependencies
        pause
        exit /b 1
    )
)
echo ✅ Backend dependencies ready

REM Check if Python is installed (for simple HTTP server)
cd /d "%~dp0"
echo [4/4] Checking Python for frontend server...
python --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Python not found, will try alternative method...
    set USE_NODE_SERVER=1
) else (
    echo ✅ Python found
    set USE_NODE_SERVER=0
)

echo.
echo ════════════════════════════════════════════════════════════════
echo.
echo 🚀 Starting all services...
echo.
echo Backend will run on:  http://localhost:3000
echo Frontend will run on: http://localhost:8080
echo.
echo ⚠️  DO NOT CLOSE THIS WINDOW!
echo.
echo Press Ctrl+C to stop all services
echo.
echo ════════════════════════════════════════════════════════════════
echo.

REM Start backend server
echo Starting Backend Server...
cd /d "%~dp0backend"
start "Backend Server - Port 3000" cmd /k "node server.js"

REM Wait a moment for backend to start
timeout /t 3 /nobreak >nul

REM Start frontend server
cd /d "%~dp0"
if %USE_NODE_SERVER%==1 (
    echo Starting Frontend Server with Node.js...
    start "Frontend Server - Port 8080" cmd /k "npx http-server -p 8080 -c-1"
) else (
    echo Starting Frontend Server with Python...
    start "Frontend Server - Port 8080" cmd /k "python -m http.server 8080"
)

REM Wait for servers to start
timeout /t 3 /nobreak >nul

echo.
echo ════════════════════════════════════════════════════════════════
echo.
echo ✅ ALL SERVICES STARTED SUCCESSFULLY!
echo.
echo 📱 Access your application:
echo.
echo    👤 User Portal:  http://localhost:8080/c3.html
echo    🔧 Admin Portal: http://localhost:8080/admin.html
echo.
echo 🔑 Default Admin Credentials:
echo    Username: admin
echo    Password: admin123
echo.
echo ════════════════════════════════════════════════════════════════
echo.
echo Opening User Portal in your browser...
timeout /t 2 /nobreak >nul

REM Open the application in default browser
start http://localhost:8080/c3.html

echo.
echo ✅ System is ready!
echo.
echo 💡 Tips:
echo    - Keep this window open
echo    - Backend logs in "Backend Server" window
echo    - Frontend logs in "Frontend Server" window
echo    - Press Ctrl+C in any window to stop that service
echo.
echo ════════════════════════════════════════════════════════════════
echo.
echo Press any key to open Admin Portal...
pause >nul
start http://localhost:8080/admin.html

echo.
echo System running... Press any key to exit this window.
echo (Servers will continue running in their own windows)
pause >nul
