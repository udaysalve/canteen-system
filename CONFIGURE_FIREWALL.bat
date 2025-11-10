@echo off
title Configure Windows Firewall for Canteen System
color 0E

echo.
echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║        🔥 WINDOWS FIREWALL CONFIGURATION 🔥               ║
echo ║                                                            ║
echo ║     This will allow mobile devices to connect              ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo ⚠️  IMPORTANT: This script requires Administrator privileges
echo.
echo Checking administrator rights...

REM Check for administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ ERROR: This script must be run as Administrator!
    echo.
    echo Right-click on this file and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo ✅ Running as Administrator
echo.

echo Creating firewall rules...
echo.

REM Remove existing rules if they exist
echo Removing old rules (if any)...
netsh advfirewall firewall delete rule name="Canteen - Python HTTP Server" >nul 2>&1
netsh advfirewall firewall delete rule name="Canteen - Node.js Backend" >nul 2>&1
netsh advfirewall firewall delete rule name="Canteen - Node.js Sync Server" >nul 2>&1
netsh advfirewall firewall delete rule name="Canteen - Port 8080" >nul 2>&1
netsh advfirewall firewall delete rule name="Canteen - Port 3000" >nul 2>&1
netsh advfirewall firewall delete rule name="Canteen - Port 3001" >nul 2>&1

echo.
echo Creating new firewall rules...
echo.

REM Allow Python HTTP Server (Port 8080)
echo [1/6] Creating rule for Python HTTP Server (Port 8080)...
netsh advfirewall firewall add rule name="Canteen - Port 8080" dir=in action=allow protocol=TCP localport=8080 profile=private,public
if %errorlevel% equ 0 (
    echo ✅ Port 8080 allowed
) else (
    echo ❌ Failed to create rule for port 8080
)
echo.

REM Allow Node.js Backend (Port 3000)
echo [2/6] Creating rule for Node.js Backend (Port 3000)...
netsh advfirewall firewall add rule name="Canteen - Port 3000" dir=in action=allow protocol=TCP localport=3000 profile=private,public
if %errorlevel% equ 0 (
    echo ✅ Port 3000 allowed
) else (
    echo ❌ Failed to create rule for port 3000
)
echo.

REM Allow Node.js Sync Server (Port 3001)
echo [3/6] Creating rule for Sync Server (Port 3001)...
netsh advfirewall firewall add rule name="Canteen - Port 3001" dir=in action=allow protocol=TCP localport=3001 profile=private,public
if %errorlevel% equ 0 (
    echo ✅ Port 3001 allowed
) else (
    echo ❌ Failed to create rule for port 3001
)
echo.

REM Allow Python executable
echo [4/6] Creating rule for Python...
for /f "delims=" %%i in ('where python') do set PYTHON_PATH=%%i
if defined PYTHON_PATH (
    netsh advfirewall firewall add rule name="Canteen - Python HTTP Server" dir=in action=allow program="%PYTHON_PATH%" enable=yes profile=private,public
    echo ✅ Python allowed through firewall
) else (
    echo ⚠️  Python path not found, skipping
)
echo.

REM Allow Node.js executable
echo [5/6] Creating rule for Node.js...
for /f "delims=" %%i in ('where node') do set NODE_PATH=%%i
if defined NODE_PATH (
    netsh advfirewall firewall add rule name="Canteen - Node.js Backend" dir=in action=allow program="%NODE_PATH%" enable=yes profile=private,public
    echo ✅ Node.js allowed through firewall
) else (
    echo ⚠️  Node.js path not found, skipping
)
echo.

REM Enable File and Printer Sharing for network discovery
echo [6/6] Enabling network discovery...
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=Yes profile=private >nul 2>&1
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes profile=private >nul 2>&1
echo ✅ Network discovery enabled
echo.

echo ╔════════════════════════════════════════════════════════════╗
echo ║                                                            ║
echo ║          ✅ FIREWALL CONFIGURATION COMPLETE! ✅            ║
echo ║                                                            ║
echo ╚════════════════════════════════════════════════════════════╝
echo.
echo Firewall Rules Created:
echo   ✅ Port 8080 (Frontend Server)
echo   ✅ Port 3000 (Backend Server)
echo   ✅ Port 3001 (Sync Server)
echo   ✅ Python HTTP Server
echo   ✅ Node.js Backend
echo   ✅ Network Discovery
echo.
echo 📱 Mobile devices can now connect!
echo.
echo Next steps:
echo   1. Run START_ALL_SERVERS.bat
echo   2. Connect mobile to same WiFi
echo   3. Access from mobile using your IP address
echo.
echo Press any key to exit...
pause >nul
