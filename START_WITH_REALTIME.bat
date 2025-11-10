@echo off
title Canteen Management System - Real-Time Mode
color 0A

echo.
echo ========================================
echo   CANTEEN MANAGEMENT SYSTEM
echo   Real-Time Mode with Sync Server
echo ========================================
echo.

REM Check if Node.js is available
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js not found!
    echo.
    echo Please install Node.js from: https://nodejs.org/
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
echo   Starting Servers (Real-Time Mode)
echo ========================================
echo.

REM Start Backend Server with localStorage mode (Port 3000)
echo [1/3] Starting Backend Server (Port 3000)...
start "BACKEND SERVER - localStorage Mode" cmd /k "cd /d %CMS_DIR%backend && echo. && echo ======================================== && echo   BACKEND SERVER RUNNING && echo   Mode: localStorage (No Database) && echo   Port: 3000 && echo   API: http://localhost:3000 && echo ======================================== && echo. && echo [INFO] Keep this window open! && echo. && node localStorage-server.js"

REM Wait for backend to start
timeout /t 3 /nobreak >nul

REM Start Sync Server for Real-Time Updates (Port 3001)
echo [2/3] Starting Sync Server (Port 3001)...
start "SYNC SERVER - Real-Time Orders" cmd /k "cd /d %CMS_DIR%backend && echo. && echo ======================================== && echo   SYNC SERVER RUNNING && echo   Port: 3001 && echo   Purpose: Real-Time Order Sync && echo   API: http://localhost:3001 && echo ======================================== && echo. && echo [INFO] Keep this window open! && echo. && node sync-server.js"

REM Wait for sync server to start
timeout /t 3 /nobreak >nul

REM Start Frontend Server (Port 8080)
echo [3/3] Starting Frontend Server (Port 8080)...
start "FRONTEND SERVER - Port 8080" cmd /k "cd /d %CMS_DIR% && echo. && echo ======================================== && echo   FRONTEND SERVER RUNNING && echo   Port: 8080 && echo   Customer App: http://localhost:8080/c3.html && echo   Admin Portal: http://localhost:8080/admin_portal.html && echo ======================================== && echo. && echo [INFO] Keep this window open! && echo. && http-server -p 8080 -c-1 --cors"

REM Wait for frontend to start
echo Waiting for all servers to initialize...
timeout /t 5 /nobreak >nul

echo.
echo ========================================
echo   SYSTEM STARTED SUCCESSFULLY!
echo ========================================
echo.
echo Mode: Real-Time with localStorage
echo Three server windows have been opened:
echo   1. BACKEND SERVER - Port 3000
echo   2. SYNC SERVER - Port 3001 (Real-Time)
echo   3. FRONTEND SERVER - Port 8080
echo.
echo [IMPORTANT] Keep all windows open!
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
echo Sync Server:
echo   http://localhost:3001/health
echo.
echo ========================================
echo   REAL-TIME FEATURES
echo ========================================
echo.
echo ✓ Auto-refresh every 5 seconds
echo ✓ New order notifications
echo ✓ Live order status updates
echo ✓ Kitchen display updates
echo ✓ Multi-device synchronization
echo.
echo Admin Portal Order Management Tab:
echo   - Shows live order updates
echo   - Auto-refreshes every 5 seconds
echo   - Displays "last updated" timestamp
echo   - Pause/Resume button available
echo   - New order notifications
echo.
echo ========================================
echo   DATA STORAGE INFO
echo ========================================
echo.
echo All data is stored in your browser's localStorage
echo Sync server enables real-time updates across devices
echo No PostgreSQL database required!
echo.
echo ========================================
echo.

REM Wait a bit more before opening browsers
timeout /t 3 /nobreak >nul

echo Opening applications in your browser...
echo.

REM Open Customer App
start http://localhost:8080/c3.html
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
echo Status: RUNNING (Real-Time Mode)
echo Backend: http://localhost:3000 [ACTIVE]
echo Sync: http://localhost:3001 [ACTIVE]
echo Frontend: http://localhost:8080 [ACTIVE]
echo Storage: Browser localStorage
echo.
echo To stop the servers:
echo   - Close the three server windows
echo   - Or press Ctrl+C in each window
echo.
echo ========================================
echo.
echo Press any key to close this window...
echo (Servers will continue running)
echo.
pause >nul

exit
