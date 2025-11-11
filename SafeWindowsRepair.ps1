<#
.SYNOPSIS
    SafeWindowsRepair.ps1
.DESCRIPTION
    Safely Stops And Restarts Essential Windows Services And Performs Common Network Repair Steps.
    All Visible Text And Comments Use Pascal Case Formatting.
.NOTES
    - Run This Script As Administrator.
    - This Script Executes Netsh And Ipconfig Commands That May Temporarily Disrupt Network Connectivity.
#>

#region -- Configuration Section --

# Define Services To Repair
$ServicesToRepair = @(
    "wuauserv",         # Windows Update Service
    "bits",             # Background Intelligent Transfer Service
    "TrustedInstaller", # Windows Modules Installer
    "cryptsvc",         # Cryptographic Service
    "msiserver"         # Windows Installer Service
)

# Define Log File Path
$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$LogFile = Join-Path -Path $ScriptDirectory -ChildPath "SafeWindowsRepair.log"

# Define Sleep Duration Between Service Actions (In Milliseconds)
$SleepBetweenActionsMs = 500

# Define Network Commands Timeout (Seconds)
$NetworkCommandTimeoutSec = 60

# Toggle For Performing Network Repair (Set To $True To Run Network Repair Steps)
$PerformNetworkRepair = $True

#endregion

#region -- Helper Functions Section --

# Write Log Function
Function Write-Log {
    Param(
        [Parameter(Mandatory = $True)]
        [String] $Message,

        [ValidateSet("INFO","WARN","ERROR")]
        [String] $Level = "INFO"
    )

    # Create Timestamp
    $Timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    $Line = "{0} [{1}] {2}" -f $Timestamp, $Level, $Message

    # Display Log Message
    If ($Level -eq "ERROR") {
        Write-Host $Line -ForegroundColor Red
    } ElseIf ($Level -eq "WARN") {
        Write-Host $Line -ForegroundColor Yellow
    } Else {
        Write-Host $Line
    }

    # Write To Log File
    Try {
        Add-Content -Path $LogFile -Value $Line -ErrorAction Stop
    } Catch {
        Write-Host ("{0} [WARN] Failed To Write Log: {1}" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss"), ${_}) -ForegroundColor Yellow
    }
}

# Ensure Script Is Run As Administrator
Function Ensure-Administrator {
    $IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    If (-Not $IsAdmin) {
        Write-Log "Script Must Be Run As Administrator. Exiting." "ERROR"
        Throw "Administrator Privileges Required."
    }
}

# Safely Stop A Service
Function Stop-ServiceSafe {
    Param(
        [Parameter(Mandatory = $True)]
        [String] $Svc
    )

    Try {
        $ServiceObj = Get-Service -Name $Svc -ErrorAction Stop
    } Catch {
        Write-Log ("Service Not Found: " + $Svc) "WARN"
        Return $False
    }

    If ($ServiceObj.Status -eq "Stopped") {
        Write-Log ("Service Already Stopped: " + $Svc) "INFO"
        Return $True
    }

    Try {
        Write-Log ("Stopping Service : " + $Svc) "INFO"
        Stop-Service -Name $Svc -Force -ErrorAction Stop
        Start-Sleep -Milliseconds $SleepBetweenActionsMs
        $ServiceObj.Refresh()
        If ($ServiceObj.Status -eq "Stopped") {
            Write-Log ("Stopped Service : " + $Svc) "INFO"
            Return $True
        } Else {
            Write-Log ("Service Did Not Stop As Expected: " + $Svc) "WARN"
            Return $False
        }
    } Catch {
        Write-Log ("Failed To Stop ${Svc}: ${_}") "ERROR"
        Return $False
    }
}

# Safely Start A Service
Function Start-ServiceSafe {
    Param(
        [Parameter(Mandatory = $True)]
        [String] $Svc
    )

    Try {
        $ServiceObj = Get-Service -Name $Svc -ErrorAction Stop
    } Catch {
        Write-Log ("Service Not Found: " + $Svc) "WARN"
        Return $False
    }

    If ($ServiceObj.Status -eq "Running") {
        Write-Log ("Service Already Running: " + $Svc) "INFO"
        Return $True
    }

    Try {
        Write-Log ("Starting Service : " + $Svc) "INFO"
        Start-Service -Name $Svc -ErrorAction Stop
        Start-Sleep -Milliseconds $SleepBetweenActionsMs
        $ServiceObj.Refresh()
        If ($ServiceObj.Status -eq "Running") {
            Write-Log ("Started Service : " + $Svc) "INFO"
            Return $True
        } Else {
            Write-Log ("Service Did Not Start As Expected: " + $Svc) "WARN"
            Return $False
        }
    } Catch {
        Write-Log ("Failed To Start ${Svc}: ${_}") "ERROR"
        Return $False
    }
}

#endregion

#region -- Network Repair Functions Section --

# Run A Command And Wait For Completion, Capturing Output
Function Invoke-CommandSafe {
    Param(
        [Parameter(Mandatory = $True)]
        [String] $FilePath,

        [Parameter(Mandatory = $True)]
        [String[]] $Arguments,

        [Int] $TimeoutSec = $NetworkCommandTimeoutSec
    )

    $ArgsString = $Arguments -join " "
    Write-Log ("Executing Command: " + $FilePath + " " + $ArgsString) "INFO"

    Try {
        $Proc = Start-Process -FilePath $FilePath -ArgumentList $Arguments -NoNewWindow -PassThru -Wait -WindowStyle Hidden
        # Start-Process -Wait returns when process exits; check exit code if available
        If ($Proc.ExitCode -ne $null -and $Proc.ExitCode -ne 0) {
            Write-Log ("Command Exit Code NonZero: " + $Proc.ExitCode + " For: " + $FilePath + " " + $ArgsString) "WARN"
        } Else {
            Write-Log ("Command Completed Successfully: " + $FilePath + " " + $ArgsString) "INFO"
        }
    } Catch {
        Write-Log ("Failed To Execute Command " + $FilePath + " " + $ArgsString + " : ${_}") "ERROR"
    }
}

# Reset Winsock
Function Reset-Winsock {
    Write-Log "Resetting Winsock." "INFO"
    Invoke-CommandSafe -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "System32\netsh.exe") -Arguments @("winsock","reset")
    Write-Log "Winsock Reset Completed. A Restart May Be Required For Changes To Take Effect." "INFO"
}

# Reset TcpIp Stack
Function Reset-TcpIp {
    Write-Log "Resetting TcpIp Stack." "INFO"
    Invoke-CommandSafe -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "System32\netsh.exe") -Arguments @("int","ip","reset")
    Write-Log "TcpIp Reset Completed. A Restart May Be Required For Changes To Take Effect." "INFO"
}

# Flush And Register DNS
Function Repair-Dns {
    Write-Log "Flushing Dns Resolver Cache." "INFO"
    Invoke-CommandSafe -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "System32\ipconfig.exe") -Arguments @("/flushdns")

    Write-Log "Registering Dns Names." "INFO"
    Invoke-CommandSafe -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "System32\ipconfig.exe") -Arguments @("/registerdns")
    Write-Log "Dns Repair Completed." "INFO"
}

# Renew Dhcp Lease
Function Renew-DhcpLease {
    Write-Log "Releasing Dhcp Lease." "INFO"
    Invoke-CommandSafe -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "System32\ipconfig.exe") -Arguments @("/release")

    Start-Sleep -Seconds 1

    Write-Log "Renewing Dhcp Lease." "INFO"
    Invoke-CommandSafe -FilePath (Join-Path -Path $env:SystemRoot -ChildPath "System32\ipconfig.exe") -Arguments @("/renew")
    Write-Log "Dhcp Lease Renew Completed." "INFO"
}

# Restart Key Network Services
Function Restart-NetworkServices {
    $NetworkServices = @("Dhcp","Dnscache","NlaSvc","Netman") # Dhcp, Dns Client, Network Location Awareness, Network Connections
    ForEach ($Svc In $NetworkServices) {
        Try {
            $SvcObj = Get-Service -Name $Svc -ErrorAction Stop
            If ($SvcObj.Status -eq "Running") {
                Write-Log ("Restarting Network Service: " + $Svc) "INFO"
                Restart-Service -Name $Svc -Force -ErrorAction Stop
                Start-Sleep -Milliseconds $SleepBetweenActionsMs
                Write-Log ("Restarted Network Service: " + $Svc) "INFO"
            } Else {
                Write-Log ("Starting Network Service: " + $Svc) "INFO"
                Start-Service -Name $Svc -ErrorAction Stop
                Start-Sleep -Milliseconds $SleepBetweenActionsMs
                Write-Log ("Started Network Service: " + $Svc) "INFO"
            }
        } Catch {
            Write-Log ("Failed To Restart/Start Network Service ${Svc}: ${_}") "WARN"
        }
    }
}

# High Level Network Repair Sequence
Function Repair-Network {
    Write-Log "Beginning Network Repair Sequence." "INFO"

    # Reset Winsock Then TcpIp
    Reset-Winsock
    Reset-TcpIp

    # Flush And Register Dns
    Repair-Dns

    # Renew Dhcp Lease
    Renew-DhcpLease

    # Restart Key Network Services
    Restart-NetworkServices

    Write-Log "Network Repair Sequence Completed. A System Restart Is Recommended If Connectivity Issues Persist." "INFO"
}

#endregion

#region -- Main Execution Section --

Try {
    Ensure-Administrator

    # Create Log File Header
    $Header = "=== Safe Windows Repair Run At {0} ===" -f (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    Add-Content -Path $LogFile -Value $Header

    Write-Log "Beginning Safe Windows Repair Process." "INFO"

    # Iterate Through All Services
    ForEach ($ServiceName In $ServicesToRepair) {
        $Svc = $ServiceName.Trim()
        Write-Log ("Processing Service: " + $Svc) "INFO"

        # Stop Service
        $Stopped = Stop-ServiceSafe -Svc $Svc

        # Optionally Modify Service Settings Here (Commented Out By Default)
        # Try {
        #     Set-Service -Name $Svc -StartupType Automatic -ErrorAction Stop
        #     Write-Log ("Set Startup Type Automatic For: " + $Svc) "INFO"
        # } Catch {
        #     Write-Log ("Failed To Set Startup Type For ${Svc}: ${_}") "WARN"
        # }

        # Start Service
        $Started = Start-ServiceSafe -Svc $Svc

        # Evaluate Result
        If ($Stopped -And $Started) {
            Write-Log ("Repair Completed For Service: " + $Svc) "INFO"
        } ElseIf (-Not $Stopped -And $Started) {
            Write-Log ("Service Was Not Stopped But Is Running Now: " + $Svc) "INFO"
        } Else {
            Write-Log ("Repair Incomplete For Service: " + $Svc) "WARN"
        }
    }

    Write-Log "Safe Windows Repair Service Section Completed." "INFO"

    # Perform Network Repair If Enabled
    If ($PerformNetworkRepair) {
        Repair-Network
    } Else {
        Write-Log "Network Repair Skipped (PerformNetworkRepair Is False)." "INFO"
    }

    Write-Log "Safe Windows Repair Completed Successfully." "INFO"

} Catch {
    Write-Log ("Fatal Error: ${_}") "ERROR"
    Throw
}

#endregion
