@echo off
title Stop All Services
color 0C

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                                                                ║
echo ║              🛑 STOPPING ALL SERVICES 🛑                       ║
echo ║                                                                ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

echo Stopping Backend Server (Port 3000)...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":3000" ^| find "LISTENING"') do (
    echo Killing process %%a
    taskkill /F /PID %%a >nul 2>&1
)

echo Stopping Frontend Server (Port 8080)...
for /f "tokens=5" %%a in ('netstat -aon ^| find ":8080" ^| find "LISTENING"') do (
    echo Killing process %%a
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo ✅ All services stopped!
echo.
pause
