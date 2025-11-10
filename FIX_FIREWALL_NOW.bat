@echo off
echo.
echo ========================================
echo   ADDING FIREWALL RULES
echo ========================================
echo.

REM Add firewall rules
netsh advfirewall firewall add rule name="Canteen Port 8080" dir=in action=allow protocol=TCP localport=8080
netsh advfirewall firewall add rule name="Canteen Port 3000" dir=in action=allow protocol=TCP localport=3000
netsh advfirewall firewall add rule name="Canteen Port 3001" dir=in action=allow protocol=TCP localport=3001

echo.
echo ========================================
echo   FIREWALL RULES ADDED!
echo ========================================
echo.
echo Mobile devices can now connect!
echo.
pause
