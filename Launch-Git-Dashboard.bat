@echo off
REM Git Activity Dashboard Launcher
REM Copyright 2025 Kyle J. Coder
REM Licensed under the Apache License, Version 2.0

echo.
echo =====================================================
echo      Kyle's Git Activity Dashboard Launcher
echo       Telehealth Resources Project
echo =====================================================
echo.

REM Check if we're in a git repository
if not exist ".git" (
    echo ❌ ERROR: Not in a git repository directory
    echo Please run this from Kyle's project folder
    pause
    exit /b 1
)

echo 🔍 Analyzing git repository...
echo.

REM Set default date range (last 7 days)
for /f %%i in ('powershell -command "Get-Date -Format 'yyyy-MM-dd'"') do set END_DATE=%%i
for /f %%i in ('powershell -command "(Get-Date).AddDays(-7).ToString('yyyy-MM-dd')"') do set START_DATE=%%i

echo 📅 Default date range: %START_DATE% to %END_DATE%
echo.

REM Ask user if they want to customize date range
set /p CUSTOM_RANGE="Do you want to specify a custom date range? (Y/N): "
if /i "%CUSTOM_RANGE%"=="Y" (
    set /p START_DATE="Enter start date (YYYY-MM-DD): "
    set /p END_DATE="Enter end date (YYYY-MM-DD): "
    echo.
    echo 📅 Using custom range: %START_DATE% to %END_DATE%
    echo.
)

REM Execute PowerShell script to generate data
echo 🚀 Executing PowerShell analysis...
powershell.exe -ExecutionPolicy Bypass -File "Get-GitActivity.ps1" -StartDate "%START_DATE%" -EndDate "%END_DATE%" -OutputFormat "json"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ PowerShell script failed. Please check the error above.
    echo.
    echo 📋 Troubleshooting:
    echo   1. Ensure PowerShell execution policy allows scripts
    echo   2. Verify you're in Kyle's project directory
    echo   3. Check that git is installed and accessible
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Data analysis complete!
echo.

REM Open the HTML dashboard
echo 🌐 Opening Git Activity Dashboard...
start git-activity-dashboard.html

echo.
echo 📊 Dashboard opened in your default browser.
echo    The dashboard will show Kyle's development activity
echo    for the selected date range.
echo.
echo 💡 Tips:
echo   - Use the date pickers in the dashboard to change ranges
echo   - Click "Refresh Data" to update with latest commits
echo   - Use "Export Report" to save data for records
echo.
echo Press any key to exit...
pause >nul
