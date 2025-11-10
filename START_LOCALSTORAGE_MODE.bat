@echo off
title Canteen Management System - localStorage Mode
color 0A

echo.
echo ========================================
echo   CANTEEN MANAGEMENT SYSTEM
echo   localStorage Mode (No Database)
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
echo   Starting Servers (localStorage Mode)
echo ========================================
echo.

REM Start Backend Server with localStorage mode
echo [1/2] Starting Backend Server (Port 3000)...
start "BACKEND SERVER - localStorage Mode" cmd /k "cd /d %CMS_DIR%backend && echo. && echo ======================================== && echo   BACKEND SERVER RUNNING && echo   Mode: localStorage (No Database) && echo   Port: 3000 && echo   API: http://localhost:3000 && echo   Health: http://localhost:3000/api/health && echo ======================================== && echo. && echo [INFO] Keep this window open! && echo. && node localStorage-server.js"

REM Wait for backend to start
echo Waiting for backend to initialize...
timeout /t 5 /nobreak >nul

REM Start Frontend Server
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
echo Mode: localStorage (Browser Storage)
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
echo   DATA STORAGE INFO
echo ========================================
echo.
echo All data is stored in your browser's localStorage
echo No PostgreSQL database required!
echo.
echo If you need to reset data:
echo   1. Open browser DevTools (F12)
echo   2. Go to Application -^> localStorage
echo   3. Clear all canteen-related data
echo   4. Reload the admin portal
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
echo Status: RUNNING
echo Backend: http://localhost:3000 [ACTIVE]
echo Frontend: http://localhost:8080 [ACTIVE]
echo Storage: Browser localStorage
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
