@echo off
title Canteen System - Starting Servers
color 0A

echo.
echo ========================================
echo   STARTING YOUR CANTEEN SYSTEM
echo ========================================
echo.

REM Set Node.js path explicitly
set "PATH=C:\Program Files\nodejs;%PATH%"

REM Check if Node.js is available
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js not found in PATH
    echo.
    echo Trying alternative paths...
    
    REM Try alternative Node.js locations
    if exist "C:\Program Files\nodejs\node.exe" (
        set "PATH=C:\Program Files\nodejs;%PATH%"
        echo [OK] Found Node.js in Program Files
    ) else if exist "C:\Program Files (x86)\nodejs\node.exe" (
        set "PATH=C:\Program Files (x86)\nodejs;%PATH%"
        echo [OK] Found Node.js in Program Files (x86)
    ) else (
        echo.
        echo [CRITICAL] Cannot find Node.js!
        echo.
        echo Please do ONE of these:
        echo.
        echo Option 1: Restart your computer (RECOMMENDED)
        echo   - Close this window
        echo   - Restart Windows
        echo   - Run this script again
        echo.
        echo Option 2: Reinstall Node.js
        echo   - Download from: https://nodejs.org
        echo   - Install with default settings
        echo   - Check "Add to PATH" during installation
        echo.
        pause
        exit /b 1
    )
)

echo.
echo [OK] Node.js detected!
node --version
npm --version
echo.

REM Navigate to project directory
cd /d "%~dp0"

echo ========================================
echo   INSTALLING DEPENDENCIES
echo ========================================
echo.

REM Install backend dependencies
echo [1/2] Installing backend dependencies...
cd backend
if not exist node_modules (
    echo Installing packages... (this may take 1-2 minutes)
    call npm install
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install backend dependencies
        echo.
        echo Try running: npm install
        echo in the backend folder manually
        pause
        exit /b 1
    )
    echo [OK] Backend dependencies installed!
) else (
    echo [OK] Backend dependencies already installed
)
cd ..

echo.
echo [2/2] Installing http-server...
call npm list -g http-server >nul 2>&1
if %errorlevel% neq 0 (
    echo Installing http-server globally...
    call npm install -g http-server
    if %errorlevel% neq 0 (
        echo [WARNING] Could not install http-server globally
        echo Will use npx instead
    )
)

echo.
echo ========================================
echo   STARTING SERVERS
echo ========================================
echo.

REM Kill any existing processes on ports 3000 and 8080
echo Checking for existing servers...
netstat -ano | findstr :3000 >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Port 3000 is in use, attempting to free it...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do taskkill /F /PID %%a >nul 2>&1
)

netstat -ano | findstr :8080 >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Port 8080 is in use, attempting to free it...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do taskkill /F /PID %%a >nul 2>&1
)

echo.
echo [1/2] Starting Backend Server (Port 3000)...
start "BACKEND - Port 3000" cmd /k "cd /d %~dp0backend && title BACKEND SERVER - Port 3000 && echo. && echo ======================================== && echo   BACKEND SERVER && echo   Status: STARTING... && echo ======================================== && echo. && npm start"

echo Waiting for backend to initialize...
timeout /t 5 /nobreak >nul

echo [2/2] Starting Frontend Server (Port 8080)...
start "FRONTEND - Port 8080" cmd /k "cd /d %~dp0 && title FRONTEND SERVER - Port 8080 && echo. && echo ======================================== && echo   FRONTEND SERVER && echo   Status: STARTING... && echo ======================================== && echo. && npx http-server -p 8080 -c-1 --cors"

echo.
echo Waiting for frontend to initialize...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo   SERVERS STARTED!
echo ========================================
echo.
echo Two server windows are now running:
echo   [1] BACKEND - Port 3000
echo   [2] FRONTEND - Port 8080
echo.
echo [IMPORTANT] Keep both windows open!
echo.
echo ========================================
echo   ACCESS YOUR APPLICATIONS
echo ========================================
echo.
echo Customer App:
echo   http://localhost:8080/c3.html
echo.
echo Admin Portal:
echo   http://localhost:8080/admin_portal.html
echo   Login: admin / admin123
echo.
echo Backend Health Check:
echo   http://localhost:3000/api/health
echo.
echo ========================================
echo.

echo Opening applications in browser...
timeout /t 3 /nobreak >nul

REM Open customer app
start http://localhost:8080/c3.html

timeout /t 2 /nobreak >nul

REM Open admin portal
start http://localhost:8080/admin_portal.html

echo.
echo [SUCCESS] Applications opened in browser!
echo.
echo If pages don't load:
echo   1. Wait 10-15 seconds
echo   2. Refresh your browser (F5)
echo   3. Check that both server windows are running
echo.
echo To stop servers: Close the two server windows
echo.
echo Press any key to close this window...
echo (Servers will continue running)
pause >nul
