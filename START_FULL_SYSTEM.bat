@echo off
echo ========================================
echo  Canteen Management System - Full Setup
echo ========================================
echo.

REM Refresh environment variables to detect newly installed Node.js
call refreshenv 2>nul

echo Step 1: Checking Node.js installation...
echo.

where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js not found in PATH!
    echo.
    echo 📋 SOLUTIONS:
    echo 1. Close this window and restart your computer
    echo 2. Then run this script again
    echo.
    echo OR manually add Node.js to PATH:
    echo 1. Search for "Environment Variables" in Windows
    echo 2. Edit "Path" variable
    echo 3. Add: C:\Program Files\nodejs\
    echo 4. Restart this script
    echo.
    pause
    exit /b 1
)

node --version
echo ✅ Node.js is installed!
echo.

echo Step 2: Setting up Backend Server...
echo.

cd backend

if not exist node_modules (
    echo Installing backend dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies
        pause
        exit /b 1
    )
    echo ✅ Backend dependencies installed!
) else (
    echo ✅ Backend dependencies already installed
)

echo.
echo Step 3: Checking environment configuration...
echo.

if not exist .env (
    echo Creating .env file from template...
    copy .env.example .env
    echo ⚠️  Please configure your database settings in backend\.env
    echo    For now, the system will work with localStorage
)

echo.
echo Step 4: Starting Backend Server...
echo.
echo 🚀 Backend will run on: http://localhost:3000
echo.

start "Canteen Backend Server" cmd /k "cd /d %~dp0backend && npm start"

timeout /t 3 /nobreak >nul

cd ..

echo.
echo Step 5: Starting Frontend Server...
echo.
echo 🚀 Frontend will run on: http://localhost:8080
echo.

start "Canteen Frontend Server" cmd /k "npx http-server -p 8080 -c-1"

timeout /t 3 /nobreak >nul

echo.
echo ========================================
echo  ✅ SYSTEM STARTED SUCCESSFULLY!
echo ========================================
echo.
echo 🌐 Access your applications:
echo.
echo 📱 Customer App:
echo    http://localhost:8080/c3.html
echo.
echo 🏪 Admin Portal:
echo    http://localhost:8080/admin_portal.html
echo    Login: admin / admin123
echo.
echo 🔧 Backend API:
echo    http://localhost:3000
echo.
echo 📋 QUICK TEST:
echo 1. Open http://localhost:8080/c3.html
echo 2. Login/Signup as customer
echo 3. Add items to cart and place order
echo 4. Test receipt generation
echo 5. Access admin portal and initialize sample data
echo.
echo ⚠️  Keep both terminal windows open!
echo    Closing them will stop the servers.
echo.
echo Press any key to open the customer app in your browser...
pause >nul

start http://localhost:8080/c3.html

echo.
echo Opening customer app...
timeout /t 2 /nobreak >nul
echo.
echo Opening admin portal...
start http://localhost:8080/admin_portal.html

echo.
echo ✅ Both applications are now running!
echo.
pause
