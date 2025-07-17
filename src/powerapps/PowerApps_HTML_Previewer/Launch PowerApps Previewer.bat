@echo off
REM PowerApps HTML Previewer - Main Launcher
REM Double-click this file to launch the PowerApps HTML preview generator

title PowerApps HTML Previewer
color 0B

echo.
echo ==========================================
echo    PowerApps HTML Previewer v1.0
echo ==========================================
echo.
echo This tool converts PowerApps JSON files to HTML previews
echo.

REM Check if PowerShell is available
where powershell >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: PowerShell is required but not found!
    echo Please install PowerShell and try again.
    pause
    exit /b 1
)

REM Launch the PowerShell GUI script
echo Starting file picker...
echo.

REM Get the directory where this batch file is located
set "SCRIPT_DIR=%~dp0"

REM Launch the GUI PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "%SCRIPT_DIR%scripts\PowerApps-GUI-Launcher.ps1"

REM Check if the PowerShell script succeeded
if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo       Preview Generated Successfully!
    echo ==========================================
    echo.
    echo Your HTML preview has been created and opened.
    echo Generated files are saved in the 'generated_previews' folder.
    echo.
) else (
    echo.
    echo ==========================================
    echo            Operation Cancelled
    echo ==========================================
    echo.
    echo No file was selected or an error occurred.
    echo.
)

echo Press any key to exit...
pause >nul
