@echo off
echo ========================================
echo  Canteen Management System - Direct Open
echo ========================================
echo.
echo Opening files directly in your default browser...
echo.
echo 🍽️ Opening Main Canteen App...
start "" "c3.html"

timeout /t 2 /nobreak >nul

echo 🏪 Opening Admin Portal...
start "" "admin_portal.html"

echo.
echo ✅ Both applications should now be open in your browser!
echo.
echo 📋 QUICK TESTING:
echo.
echo Main App (c3.html):
echo - Login/Signup as customer
echo - Browse menu and add items to cart
echo - Test cash payment and receipt generation
echo.
echo Admin Portal (admin_portal.html):
echo - Login with: admin / admin123
echo - Click "Initialize Sample Data" button
echo - Test all admin functions
echo.
echo ⚠️  NOTE: Some advanced features may be limited when opening
echo    files directly due to browser security restrictions.
echo    For full functionality, install Python or Node.js and use
echo    the start-local-test.bat file.
echo.
pause
