@echo off
title Canteen Management System - Startup
color 0A

echo.
echo ========================================
echo   CANTEEN MANAGEMENT SYSTEM
echo   One-Click Complete Startup
echo ========================================
echo.

REM Check if Node.js is available
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js not found!
    echo.
    echo Please restart your computer after installing Node.js
    echo Then run this script again.
    echo.
    pause
    exit /b 1
)

echo [OK] Node.js detected
node --version
echo.

REM Get the current directory
set "CMS_DIR=%~dp0"
cd /d "%CMS_DIR%"

echo ========================================
echo   STEP 1: Installing Dependencies
echo ========================================
echo.

REM Install backend dependencies
echo [1/2] Installing backend dependencies...
cd backend
if not exist node_modules (
    echo Installing backend packages...
    call npm install --silent
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install backend dependencies
        pause
        exit /b 1
    )
    echo [OK] Backend dependencies installed
) else (
    echo [OK] Backend dependencies already installed
)
cd ..

REM Install http-server globally if needed
echo.
echo [2/2] Checking http-server...
call npm list -g http-server >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing http-server globally...
    call npm install -g http-server --silent
    echo [OK] http-server installed
) else (
    echo [OK] http-server already installed
)

echo.
echo ========================================
echo   STEP 2: Starting Servers
echo ========================================
echo.

REM Start Backend Server in a new window
echo [1/2] Starting Backend Server (Port 3000)...
start "BACKEND SERVER - Port 3000" cmd /k "cd /d %CMS_DIR%backend && echo. && echo ======================================== && echo   BACKEND SERVER RUNNING && echo   Port: 3000 && echo   API: http://localhost:3000 && echo   Health: http://localhost:3000/api/health && echo ======================================== && echo. && echo [INFO] Keep this window open! && echo. && npm start"

REM Wait for backend to start
echo Waiting for backend to initialize...
timeout /t 5 /nobreak >nul

REM Start Frontend Server in a new window
echo [2/2] Starting Frontend Server (Port 8080)...
start "FRONTEND SERVER - Port 8080" cmd /k "cd /d %CMS_DIR% && echo. && echo ======================================== && echo   FRONTEND SERVER RUNNING && echo   Port: 8080 && echo   Customer App: http://localhost:8080/c3.html && echo   Admin Portal: http://localhost:8080/admin_portal.html && echo ======================================== && echo. && echo [INFO] Keep this window open! && echo. && npx http-server -p 8080 -c-1 --cors"

REM Wait for frontend to start
echo Waiting for frontend to initialize...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo   SYSTEM STARTED SUCCESSFULLY!
echo ========================================
echo.
echo Two server windows have been opened:
echo   1. BACKEND SERVER - Port 3000
echo   2. FRONTEND SERVER - Port 8080
echo.
echo [IMPORTANT] Keep both windows open!
echo.
echo ========================================
echo   YOUR APPLICATIONS
echo ========================================
echo.
echo Customer App:
echo   http://localhost:8080/c3.html
echo.
echo Admin Portal:
echo   http://localhost:8080/admin_portal.html
echo   Login: admin / admin123
echo.
echo Backend API:
echo   http://localhost:3000/api/health
echo.
echo ========================================
echo   QUICK TEST CHECKLIST
echo ========================================
echo.
echo 1. Customer App:
echo    - Create account and login
echo    - Add items to cart
echo    - Place order with cash
echo    - View and print receipt
echo.
echo 2. Admin Portal:
echo    - Login with admin/admin123
echo    - Click "Initialize Sample Data"
echo    - Test menu management
echo    - Test user management
echo.
echo ========================================
echo.

REM Wait a bit more before opening browsers
timeout /t 3 /nobreak >nul

echo Opening applications in your browser...
echo.

REM Open Customer App
start h:8080/c3.htmlttp://localhost
timeout /t 2 /nobreak >nul

REM Open Admin Portal
start http://localhost:8080/admin_portal.html

echo.
echo [SUCCESS] Both applications opened in browser!
echo.
echo ========================================
echo   SYSTEM STATUS
echo ========================================
echo.
echo Status: RUNNING
echo Backend: http://localhost:3000 [ACTIVE]
echo Frontend: http://localhost:8080 [ACTIVE]
echo.
echo To stop the servers:
echo   - Close the two server windows
echo   - Or press Ctrl+C in each window
echo.
echo ========================================
echo.
echo Press any key to close this window...
echo (Servers will continue running)
echo.
pause >nul

exit
