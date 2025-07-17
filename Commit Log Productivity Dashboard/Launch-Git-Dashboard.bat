@echo off
REM Git Activity Dashboard Launcher - Portable Version
REM Copyright 2025 Kyle J. Coder
REM Licensed under the Apache License, Version 2.0

echo.
echo =====================================================
echo      Git Activity Dashboard Launcher
echo         Portable Self-Contained Version
echo =====================================================
echo.

REM Get the directory where this batch file is located
set "DASHBOARD_DIR=%~dp0"
cd /d "%DASHBOARD_DIR%"

echo 🔍 Dashboard location: %DASHBOARD_DIR%
echo 📂 Searching for git repository...

REM The PowerShell script will auto-detect the git repository
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
powershell.exe -ExecutionPolicy Bypass -File "%DASHBOARD_DIR%Get-GitActivity.ps1" -StartDate "%START_DATE%" -EndDate "%END_DATE%" -OutputFormat "json"

if %ERRORLEVEL% neq 0 (
    echo.
    echo ❌ PowerShell script failed. Please check the error above.
    echo.
    echo 📋 Troubleshooting:
    echo   1. Ensure PowerShell execution policy allows scripts
    echo   2. Verify this folder is in or under a git repository
    echo   3. Check that git is installed and accessible
    echo   4. Try running: Get-GitActivity.ps1 manually
    echo.
    pause
    exit /b 1
)

echo.
echo ✅ Data analysis complete!
echo.

REM Open the HTML dashboard
echo 🌐 Opening Git Activity Dashboard...
start "%DASHBOARD_DIR%git-activity-dashboard.html"

echo.
echo 📊 Dashboard opened in your default browser.
echo    The dashboard will show development activity
echo    for the selected date range from the detected git repository.
echo.
echo 💡 Tips:
echo   - Use the date pickers in the dashboard to change ranges
echo   - Click "Refresh Data" to update with latest commits
echo   - Use "Export Report" to save data for records
echo   - Copy this entire folder to other git repositories for reuse
echo.
echo Press any key to exit...
pause >nul
