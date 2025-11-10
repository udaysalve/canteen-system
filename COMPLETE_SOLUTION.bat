@echo off
title Gajanan Canteen - Complete One-Click Solution
color 0A

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║        🍽️  GAJANAN CANTEEN - ONE CLICK SOLUTION 🍽️       ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

REM Kill any existing processes
echo [1/4] Stopping old servers...
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
timeout /t 2 >nul
echo ✅ Old servers stopped
echo.

REM Start Backend Server
echo [2/4] Starting Backend Server (Port 3000)...
start "Backend Server" /MIN cmd /k "cd backend && node localStorage-server.js"
timeout /t 3 >nul
echo ✅ Backend server started
echo.

REM Start Sync Server
echo [3/4] Starting Sync Server (Port 3001)...
start "Sync Server" /MIN cmd /k "cd backend && node sync-server.js"
timeout /t 3 >nul
echo ✅ Sync server started
echo.

REM Start Frontend Server
echo [4/4] Starting Frontend Server (Port 8080)...
start "Frontend Server" /MIN cmd /k "python -m http.server 8080"
timeout /t 3 >nul
echo ✅ Frontend server started
echo.

echo ╔════════════════════════════════════════════════════════════╗
echo ║                   ✅ ALL SYSTEMS READY!                    ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo 🖥️  Access on THIS COMPUTER:
echo    Customer App:  http://localhost:8080/c3.html
echo    Admin Portal:  http://localhost:8080/admin_portal.html
echo    QR Codes:      http://localhost:8080/qr-codes.html
echo.
echo 📱 For Mobile Access:
echo    Since network blocking is preventing direct connection,
echo    use QR codes to share the localhost URL, or
echo    access the system on this computer only.
echo.
echo 💡 Admin Login: admin / admin123
echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║              Opening Admin Portal in 3 seconds...          ║
echo ╚════════════════════════════════════════════════════════════╝
echo.

timeout /t 3 >nul
start http://localhost:8080/admin_portal.html

echo.
echo ✅ System is running!
echo.
echo Keep this window open to keep servers running.
echo Press any key to stop all servers and exit...
pause >nul

REM Stop all servers
echo.
echo Stopping all servers...
taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM node.exe >nul 2>&1
echo ✅ All servers stopped
echo.
timeout /t 2 >nul
