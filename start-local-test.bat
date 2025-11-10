@echo off
echo ========================================
echo  Canteen Management System - Local Test
echo ========================================
echo.

echo Checking for available HTTP server options...
echo.

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% == 0 (
    echo Python found! Starting Python HTTP server...
    echo.
    echo Open your browser and go to:
    echo http://localhost:8000/c3.html
    echo.
    echo For Admin Portal:
    echo http://localhost:8000/admin_portal.html
    echo.
    echo Press Ctrl+C to stop the server
    echo.
    python -m http.server 8000
    goto :end
)

REM Check if Node.js is available
node --version >nul 2>&1
if %errorlevel% == 0 (
    echo Node.js found! Installing and starting HTTP server...
    echo.
    npx http-server -p 8000
    goto :end
)

REM If neither Python nor Node.js is available
echo.
echo ❌ ERROR: Neither Python nor Node.js is installed!
echo.
echo 📋 SOLUTIONS:
echo.
echo 1. EASIEST: Just open the HTML files directly in your browser:
echo    - Right-click on c3.html and select "Open with" → Your Browser
echo    - For admin: Right-click on admin_portal.html and open in browser
echo.
echo 2. Install Python (Recommended):
echo    - Download from: https://www.python.org/downloads/
echo    - During installation, check "Add Python to PATH"
echo    - Then run this script again
echo.
echo 3. Install Node.js:
echo    - Download from: https://nodejs.org/
echo    - Install and then run this script again
echo.
echo 4. Use Visual Studio Code with Live Server extension:
echo    - Install VS Code
echo    - Install "Live Server" extension
echo    - Right-click on c3.html and select "Open with Live Server"
echo.
echo ⚠️  NOTE: Some features (like receipt generation) may not work
echo    without a proper HTTP server due to browser security restrictions.
echo.

:end
pause
