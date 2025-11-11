@echo off
:: ================================================================
:: File Name   : Remove-SafeRepairBackups.bat
:: Description : Safely Deletes Backup And Log Files Created By Safe Windows Repair Script.
:: Author      : DURGAAI SOLUTIONS
:: Note        : This File Uses Pascal Case For All Text And Comments.
:: ================================================================

:: Check Administrator Privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Please Run This File As Administrator.
    pause
    exit /b
)

:: Set Working Directory (Same Directory As This Batch File)
cd /d "%~dp0"

:: Define Log And Backup File Patterns
set "BackupPattern=*.bak"
set "LogPattern=SafeWindowsRepair.log"

:: Display Header
echo ===========================================================
echo   Remove Safe Repair Backups - DURGAAI SOLUTIONS
echo ===========================================================
echo.

:: Check If Log File Exists
if exist "%LogPattern%" (
    echo [INFO] Found Log File: %LogPattern%
    del /f /q "%LogPattern%"
    echo [INFO] Deleted Log File Successfully.
) else (
    echo [WARN] No Log File Found Matching Pattern: %LogPattern%
)

:: Search For Backup Files In Current Directory
set "FoundBackups=False"
for %%f in (%BackupPattern%) do (
    if exist "%%f" (
        echo [INFO] Found Backup File: %%f
        del /f /q "%%f"
        echo [INFO] Deleted Backup File: %%f
        set "FoundBackups=True"
    )
)

:: Delete Any Temporary Repair Files
if exist "%~dp0Temp" (
    echo [INFO] Found Temp Directory. Deleting...
    rmdir /s /q "%~dp0Temp"
    echo [INFO] Deleted Temp Directory Successfully.
)

:: Check If Any Backups Were Found
if "%FoundBackups%"=="False" (
    echo [WARN] No Backup Files Found Matching Pattern: %BackupPattern%
)

:: Final Confirmation
echo.
echo ===========================================================
echo   Cleanup Process Completed Successfully.
echo   All Backup And Log Files Have Been Removed.
echo ===========================================================
echo.
pause
exit /b
