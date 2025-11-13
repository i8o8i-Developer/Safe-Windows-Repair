<#
.SYNOPSIS
    Safe Windows Repair Utility (SafeWindowsRepair.ps1)

.DESCRIPTION
    Performs A Set Of Common Windows Repair And Cleanup Tasks Safely:
      - Logging To A TimeStamped Log File In Script Folder
      - Checks For Elevation (Admin)
      - Stops/Starts Specified Services
      - Clears Temp Folders And Windows Update Cache (SoftwareDistribution)
      - Runs DISM Restore-Health And SFC /Scannow
      - Resets Winsock And Flushes DNS
      - Optionally Reboots
#>

#region --- Helper Functions ---

function Write-Log {
    param(
        [Parameter(Mandatory = $true)][string]$Message,
        [ValidateSet('INFO','WARN','ERROR','DEBUG')][string]$Level = 'INFO'
    )

    $TimeStamp = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    $Line = "$TimeStamp [$Level] $Message"
    # Write To Console With Color
    switch ($Level) {
        'INFO'  { Write-Host $Line -ForegroundColor Green }
        'WARN'  { Write-Host $Line -ForegroundColor Yellow }
        'ERROR' { Write-Host $Line -ForegroundColor Red }
        'DEBUG' { Write-Host $Line -ForegroundColor Cyan }
    }
    # Append To Log File If Global Variable Set
    if ($Script:LogPath) {
        try {
            Add-Content -Path $Script:LogPath -Value $Line -ErrorAction Stop
        } catch {
            Write-Host "Failed To Write To Log : $($_.Exception.Message)" -ForegroundColor Red
        }
    }
}

function Ensure-Administrator {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Error "This Script Must Be Run As Administrator. Right-Click And 'Run As Administrator'."
        Exit 1
    } else {
        Write-Log "Confirmed Running As Administrator." "DEBUG"
    }
}

function Backup-Folder {
    param(
        [Parameter(Mandatory = $true)][string]$FolderPath,
        [string]$BackupRoot = "$env:TEMP\SafeWindowsRepairBackups"
    )

    try {
        if (-not (Test-Path -Path $FolderPath)) {
            Write-Log "Backup-Folder: Source Path ${FolderPath} Does Not Exist, Skipping." "WARN"
            return $null
        }
        New-Item -Path $BackupRoot -ItemType Directory -Force | Out-Null
        $TimeStamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
        $SafeName = ([IO.Path]::GetFileName($FolderPath) -replace '[^a-zA-Z0-9\-_.]','_')
        $Dest = Join-Path -Path $BackupRoot -ChildPath "${SafeName}_Backup_${TimeStamp}"
        Write-Log "Backing up ${FolderPath} to ${Dest}." "INFO"
        Copy-Item -Path $FolderPath -Destination $Dest -Recurse -Force -ErrorAction Stop
        return $Dest
    } catch {
        Write-Log "Backup-Folder Failed For ${FolderPath}: $($_.Exception.Message)" "ERROR"
        return $null
    }
}

function Stop-ServiceSafe {
    param(
        [Parameter(Mandatory = $true)][string]$ServiceName,
        [int]$TimeoutSeconds = 20
    )

    try {
        $svc = Get-Service -Name $ServiceName -ErrorAction Stop
        if ($svc.Status -ne 'Stopped') {
            Write-Log "Stopping service ${ServiceName}..." "INFO"
            Stop-Service -Name $ServiceName -Force -ErrorAction Stop
            $Waited = 0
            while ((Get-Service -Name $ServiceName).Status -ne 'Stopped' -and $Waited -lt $TimeoutSeconds) {
                Start-Sleep -Seconds 1
                $Waited++
            }
            if ((Get-Service -Name $ServiceName).Status -ne 'Stopped') {
                Write-Log "Service ${ServiceName} did not stop within ${TimeoutSeconds} seconds." "WARN"
            } else {
                Write-Log "Service ${ServiceName} stopped." "INFO"
            }
        } else {
            Write-Log "Service ${ServiceName} Is Already Stopped." "DEBUG"
        }
    } catch {
        Write-Log "Failed To Stop ${ServiceName}: $($_.Exception.Message)" "WARN"
    }
}

function Start-ServiceSafe {
    param(
        [Parameter(Mandatory = $true)][string]$ServiceName,
        [int]$TimeoutSeconds = 20
    )

    try {
        $svc = Get-Service -Name $ServiceName -ErrorAction Stop
        if ($svc.Status -ne 'Running') {
            Write-Log "Starting Service ${ServiceName}..." "INFO"
            Start-Service -Name $ServiceName -ErrorAction Stop
            $Waited = 0
            while ((Get-Service -Name $ServiceName).Status -ne 'Running' -and $Waited -lt $TimeoutSeconds) {
                Start-Sleep -Seconds 1
                $Waited++
            }
            if ((Get-Service -Name $ServiceName).Status -ne 'Running') {
                Write-Log "Service ${ServiceName} Did Not Start Within ${TimeoutSeconds} seconds." "WARN"
            } else {
                Write-Log "Service ${ServiceName} Started." "INFO"
            }
        } else {
            Write-Log "Service ${ServiceName} Is Already Running." "DEBUG"
        }
    } catch {
        Write-Log "Could Not Start ${ServiceName}: $($_.Exception.Message)" "ERROR"
    }
}

function Clear-TempFolder {
    param(
        [Parameter(Mandatory = $true)][string]$PathToClear
    )

    try {
        if (Test-Path -Path $PathToClear) {
            Write-Log "Clearing Contents Of ${PathToClear} ..." "INFO"
            Get-ChildItem -Path $PathToClear -Force -ErrorAction SilentlyContinue | ForEach-Object {
                try {
                    Remove-Item -LiteralPath $_.FullName -Recurse -Force -ErrorAction Stop
                } catch {
                    Write-Log "Error Cleaning ${PathToClear}: $($_.Exception.Message)" "WARN"
                }
            }
            Write-Log "Cleared ${PathToClear}." "INFO"
        } else {
            Write-Log "Path ${PathToClear} Does Not Exist, Skipping." "DEBUG"
        }
    } catch {
        Write-Log "Clear-TempFolder Failed For ${PathToClear}: $($_.Exception.Message)" "ERROR"
    }
}

#endregion

#region --- Main Script Execution ---

try {
    # Location / Log File Setup
    $ScriptRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
    if (-not $ScriptRoot) { $ScriptRoot = Get-Location }
    $TimeStamp = (Get-Date).ToString('yyyyMMdd_HHmmss')
    $LogFileName = "SafeWindowsRepair_${TimeStamp}.log"
    $LogPath = Join-Path -Path $ScriptRoot -ChildPath $LogFileName
    $Script:LogPath = $LogPath

    # Create Log File
    New-Item -Path $LogPath -ItemType File -Force | Out-Null
    Write-Log "SafeWindowsRepair Started. Log: ${LogPath}" "INFO"

    Ensure-Administrator

    # Show Summary And Ask For Confirmation
    Write-Host ""
    Write-Host "This Script Will Perform Non-Destructive Repairs And Cleanup On This PC." -ForegroundColor Yellow
    Write-Host "Actions Include : stop/start Services, Clear Temp Folders, Reset Update Cache, Run DISM + SFC, Reset Network Stack." -ForegroundColor Yellow
    $Proceed = Read-Host "Type YES To Continue (Or Anything Else To Abort)"
    if ($Proceed -ne 'YES') {
        Write-Log "User Aborted The Operation." "INFO"
        Exit 0
    }

    # Services To Temporarily Stop (Example) - Safe Defaults
    $ServicesToStop = @(
        'wuauserv',     # Windows Update
        'BITS',         # Background Intelligent Transfer
        'DoSvc'         # Delivery Optimization (Optional)
    )

    # Stop services
    foreach ($Svc in $ServicesToStop) {
        Stop-ServiceSafe -ServiceName $Svc -TimeoutSeconds 25
    }

    # Back Up SoftwareDistribution And Clear It
    $SoftwareDistribution = 'C:\Windows\SoftwareDistribution'
    $BackupSd = Backup-Folder -FolderPath $SoftwareDistribution
    if ($BackupSd) {
        Write-Log "Clearing SoftwareDistribution folder ${SoftwareDistribution} ..." "INFO"
        Clear-TempFolder -PathToClear $SoftwareDistribution
    } else {
        Write-Log "Skipping Clearing SoftwareDistribution Because Backup Failed Or Path Missing." "WARN"
    }

    # Clear Common Temp Locations (Current User And System Temp)
    $UserTemp = "$env:LOCALAPPDATA\Temp"
    $SystemTemp = "$env:SystemRoot\Temp"
    Clear-TempFolder -PathToClear $UserTemp
    Clear-TempFolder -PathToClear $SystemTemp

    # Run DISM Restore-Health
    try {
        Write-Log "Running DISM Restore-Health (This Can Take Some Minutes)..." "INFO"
        # Prefer Using Start-Process To See Output
        $DismArgs = '/Online /Cleanup-Image /RestoreHealth'
        $Dism = Start-Process -FilePath dism.exe -ArgumentList $DismArgs -NoNewWindow -Wait -PassThru -ErrorAction Stop
        if ($Dism.ExitCode -eq 0) {
            Write-Log "DISM Completed Successfully." "INFO"
        } else {
            Write-Log "DISM Exited With Code ${($Dism.ExitCode)}. Check DISM Logs For Details." "WARN"
        }
    } catch {
        Write-Log "DISM Failed: $($_.Exception.Message)" "ERROR"
    }

    # Run SFC /Scannow
    try {
        Write-Log "Running sfc /scannow..." "INFO"
        $Sfc = Start-Process -FilePath sfc.exe -ArgumentList '/scannow' -NoNewWindow -Wait -PassThru -ErrorAction Stop
        if ($Sfc.ExitCode -eq 0) {
            Write-Log "SFC Completed (ExitCode 0)." "INFO"
        } else {
            Write-Log "SFC Exited With Code ${($Sfc.ExitCode)}. Review CBS Logs For Details." "WARN"
        }
    } catch {
        Write-Log "SFC Failed: $($_.Exception.Message)" "ERROR"
    }

    # Reset Network Stack: Winsock, TCP/IP, Flush DNS
    try {
        Write-Log "Resetting Winsock And TCP/IP Stack, Flushing DNS..." "INFO"
        netsh winsock reset | Out-Null
        netsh int ip reset | Out-Null
        ipconfig /flushdns | Out-Null
        Write-Log "Network Stack Reset Commands Executed. A Reboot May Be Required For Full Effect." "INFO"
    } catch {
        Write-Log "Network Reset Commands Failed : $($_.Exception.Message)" "WARN"
    }

    # Clear Windows Update Temporary DB Files (If Any Left) - Only If Service Stopped Earlier
    try {
        if (-not (Get-Service -Name 'wuauserv' -ErrorAction SilentlyContinue) -or (Get-Service -Name 'wuauserv').Status -ne 'Running') {
            $WUCache = Join-Path -Path $SoftwareDistribution -ChildPath 'DataStore'
            if (Test-Path -Path $WUCache) {
                Write-Log "Clearing WU DataStore ${WUCache} ..." "INFO"
                Clear-TempFolder -PathToClear $WUCache
            } else {
                Write-Log "WU DataStore path ${WUCache} not found, skipping." "DEBUG"
            }
        } else {
            Write-Log "Windows Update Service Running; Skipping DataStore Clear For Safety." "DEBUG"
        }
    } catch {
        Write-Log "Failed Clearing WU DataStore: $($_.Exception.Message)" "WARN"
    }

    # Start Services Back Up
    foreach ($Svc in $ServicesToStop) {
        Start-ServiceSafe -ServiceName $Svc -TimeoutSeconds 30
    }

    Write-Log "All Operations Complete. Review The Log At ${LogPath}." "INFO"

    # Suggest reboot
    $RebootAnswer = Read-Host "Do You Want To Reboot Now? Type YES To Reboot"
    if ($RebootAnswer -eq 'YES') {
        Write-Log "User Chose To Reboot. Initiating Reboot..." "INFO"
        Restart-Computer -Force
    } else {
        Write-Log "User Chose Not To Reboot Now." "INFO"
    }

} catch {
    Write-Log "Fatal Error In Main Script : $($_.Exception.Message)" "ERROR"
    Write-Host "Script Encountered A Fatal Error. See Log ${LogPath} For Details." -ForegroundColor Red
    Exit 1
}

#endregion
