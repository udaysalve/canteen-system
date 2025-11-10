@echo off
echo ========================================
echo  Starting Frontend Server
echo ========================================
echo.

echo Starting HTTP server on port 8080...
echo.
echo Your apps will be available at:
echo - Customer App: http://localhost:8080/c3.html
echo - Admin Portal: http://localhost:8080/admin_portal.html
echo.

npx http-server -p 8080 -c-1

pause
