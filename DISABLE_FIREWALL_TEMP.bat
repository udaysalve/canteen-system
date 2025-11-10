@echo off
echo.
echo ============================================
echo   TEMPORARILY DISABLING WINDOWS FIREWALL
echo ============================================
echo.
echo This will disable firewall for testing only
echo You should re-enable it after testing
echo.
pause

netsh advfirewall set allprofiles state off

echo.
echo ============================================
echo   FIREWALL DISABLED
echo ============================================
echo.
echo Now try accessing from mobile:
echo http://10.199.240.223:8080/c3.html
echo.
echo.
echo To RE-ENABLE firewall later, run:
echo ENABLE_FIREWALL.bat
echo.
pause
