@echo off
echo ========================================
echo  Canteen System - Quick Start
echo ========================================
echo.

echo 🔍 Checking Node.js...
echo.

REM Try to find Node.js in common installation paths
set "NODE_PATH="
if exist "C:\Program Files\nodejs\node.exe" set "NODE_PATH=C:\Program Files\nodejs"
if exist "C:\Program Files (x86)\nodejs\node.exe" set "NODE_PATH=C:\Program Files (x86)\nodejs"
if exist "%APPDATA%\npm\node.exe" set "NODE_PATH=%APPDATA%\npm"

if defined NODE_PATH (
    echo ✅ Found Node.js at: %NODE_PATH%
    set "PATH=%NODE_PATH%;%PATH%"
) else (
    echo ⚠️  Node.js not found in common locations
    echo    Trying system PATH...
)

REM Test if node works
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERROR: Cannot run Node.js
    echo.
    echo 📋 PLEASE DO THIS:
    echo 1. Close ALL command windows
    echo 2. Restart your computer
    echo 3. Run this script again
    echo.
    echo This is needed for Windows to recognize Node.js
    echo.
    pause
    exit /b 1
)

echo.
node --version
npm --version
echo ✅ Node.js is working!
echo.

echo ========================================
echo  Starting Services...
echo ========================================
echo.

REM Install http-server globally if not present
echo 📦 Checking http-server...
call npm list -g http-server >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing http-server...
    call npm install -g http-server
)

echo.
echo 🚀 Starting Frontend Server...
echo.

REM Start frontend server in a new window
start "Frontend - Port 8080" cmd /k "cd /d %~dp0 && npx http-server -p 8080 -c-1 && echo Frontend running on http://localhost:8080"

timeout /t 3 /nobreak >nul

echo.
echo 🚀 Starting Backend Server...
echo.

REM Install backend dependencies if needed
cd backend
if not exist node_modules (
    echo Installing backend dependencies...
    call npm install
)

REM Start backend server in a new window
start "Backend - Port 3000" cmd /k "cd /d %~dp0backend && npm start"

cd ..

timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo  ✅ SYSTEM IS RUNNING!
echo ========================================
echo.
echo 🌐 Your Applications:
echo.
echo 📱 Customer App:
echo    http://localhost:8080/c3.html
echo.
echo 🏪 Admin Portal:
echo    http://localhost:8080/admin_portal.html
echo    Credentials: admin / admin123
echo.
echo 🔧 Backend API:
echo    http://localhost:3000
echo.
echo.
echo 📋 TESTING CHECKLIST:
echo ✓ Open customer app
echo ✓ Login/Signup
echo ✓ Add items to cart
echo ✓ Place order with cash payment
echo ✓ Test receipt generation
echo ✓ Open admin portal
echo ✓ Click "Initialize Sample Data"
echo ✓ Test all admin features
echo.
echo ⚠️  IMPORTANT: Keep the two server windows open!
echo    Closing them will stop the servers.
echo.

echo Opening applications in browser...
timeout /t 2 /nobreak >nul

start http://localhost:8080/c3.html

timeout /t 2 /nobreak >nul

start http://localhost:8080/admin_portal.html

echo.
echo ✅ Applications opened in your browser!
echo.
echo Press any key to exit this window...
echo (The servers will keep running in their own windows)
echo.
pause >nul
