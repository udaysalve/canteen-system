@echo off
echo ========================================
echo   GITHUB UPLOAD HELPER
echo ========================================
echo.
echo This script will help you upload your project to GitHub
echo Repository: https://github.com/udaysalve/CMS
echo.
echo STEPS TO UPLOAD:
echo.
echo 1. Open your web browser
echo 2. Go to: https://github.com/udaysalve/CMS
echo 3. Click "Add file" then "Upload files"
echo 4. Drag and drop ALL files from this folder
echo 5. Add commit message: "Complete Canteen Management System"
echo 6. Click "Commit changes"
echo.
echo Your project folder is located at:
echo %CD%
echo.
echo Opening GitHub repository in browser...
start https://github.com/udaysalve/CMS
echo.
echo Opening project folder...
start .
echo.
pause
