@echo off
echo ========================================
echo  Starting Backend Server
echo ========================================
echo.

cd backend

echo Installing dependencies...
call npm install

echo.
echo Starting server on port 3000...
echo.

npm start

pause
