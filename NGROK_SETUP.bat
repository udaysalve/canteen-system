@echo off
title Ngrok HTTPS Tunnel Setup
color 0A

echo ============================================
echo    NGROK HTTPS TUNNEL FOR CANTEEN CMS
echo ============================================
echo.

REM Check if ngrok exists
where ngrok >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Ngrok not found!
    echo.
    echo Please download ngrok from:
    echo https://ngrok.com/download
    echo.
    echo Extract it to a folder and add to PATH, or:
    echo Place ngrok.exe in this folder: %CD%
    echo.
    pause
    exit /b 1
)

echo [OK] Ngrok found!
echo.
echo Starting HTTPS tunnel on port 8080...
echo.
echo ============================================
echo   YOUR SECURE URLS WILL APPEAR BELOW
echo ============================================
echo.
echo Copy the HTTPS URL and use it on your mobile!
echo Example: https://abc123.ngrok.io/c3.html
echo.
echo Press Ctrl+C to stop the tunnel
echo.

REM Start ngrok tunnel
ngrok http 8080

pause
