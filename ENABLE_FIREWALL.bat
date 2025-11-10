@echo off
echo.
echo ============================================
echo   RE-ENABLING WINDOWS FIREWALL
echo ============================================
echo.

netsh advfirewall set allprofiles state on

echo.
echo ============================================
echo   FIREWALL RE-ENABLED
echo ============================================
echo.
pause
