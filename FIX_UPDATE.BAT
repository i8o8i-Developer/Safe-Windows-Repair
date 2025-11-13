@echo off
title Ultimate Windows Update Reset Script - 2025 Edition
color 0A

:: ---------------------------
:: Admin Rights Check
:: ---------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo [!] This Script Requires Administrator Privileges.
    echo     Right-Click And Run As Administrator.
    pause
    exit
)


:: ---------------------------
:: Stop Windows Update Services
:: ---------------------------
echo Stopping Services... 
net stop wuauserv  2>&1
net stop cryptSvc  2>&1
net stop bits  2>&1
net stop msiserver  2>&1

:: ---------------------------
:: Clean BITS Job Queue
:: ---------------------------
echo Cleaning Background Intelligent Transfer Queue... 
bitsadmin /reset /allusers  2>&1

:: ---------------------------
:: Delete Update Cache And Logs
:: ---------------------------
echo Cleaning Update Cache And Logs... 
del /f /s /q %windir%\SoftwareDistribution\Download\*  2>&1
del /f /s /q %windir%\SoftwareDistribution\DataStore\*  2>&1
del /f /s /q C:\Windows\SoftwareDistribution\DeliveryOptimization\*  2>&1
del /f /s /q C:\Windows\Logs\WindowsUpdate\*  2>&1

:: Rename Update Folders
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old  2>&1
ren C:\Windows\System32\catroot2 catroot2.old  2>&1

:: ---------------------------
:: Restart Update Services
:: ---------------------------
echo Restarting Update Services... 
net start wuauserv  2>&1
net start cryptSvc  2>&1
net start bits  2>&1
net start msiserver  2>&1

:: ---------------------------
:: Final Message
:: ---------------------------
echo.
echo -------------------------------------------------
echo [✓] Windows Update Reset Completed Successfully.
echo Log Saved At: %logfile%
echo -------------------------------------------------
pause
exit