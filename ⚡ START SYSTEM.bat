@echo off
title Gajanan Canteen System
color 0A

echo.
echo ╔═══════════════════════════════════════╗
echo ║  GAJANAN CANTEEN - STARTING SYSTEM    ║
echo ╚═══════════════════════════════════════╝
echo.

echo Starting servers...
echo.

echo [1/3] Backend Server (Port 3000)...
start "Backend" cmd /k "cd /d %~dp0backend && node localStorage-server.js"
timeout /t 2 >nul

echo [2/3] Sync Server (Port 3001)...
start "Sync" cmd /k "cd /d %~dp0backend && node sync-server.js"
timeout /t 2 >nul

echo [3/3] Frontend Server (Port 8080)...
start "Frontend" cmd /k "cd /d %~dp0 && python -m http.server 8080"
timeout /t 3 >nul

echo.
echo ╔═══════════════════════════════════════╗
echo ║  ALL SERVERS RUNNING!                 ║
echo ╚═══════════════════════════════════════╝
echo.
echo Access URLs:
echo   Admin:    http://localhost:8080/admin_portal.html
echo   Customer: http://localhost:8080/c3.html
echo   QR Codes: http://localhost:8080/qr-codes.html
echo.
echo Login: admin / admin123
echo.
echo Opening admin portal...
timeout /t 2 >nul
start http://localhost:8080/admin_portal.html

echo.
echo System is ready!
echo Close this window to stop.
pause
