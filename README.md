# 🔧 Safe Windows Repair

<div align="center">

![Windows Logo](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![GitHub](https://img.shields.io/badge/GitHub-i8o8i--Developer-181717?style=for-the-badge&logo=github&logoColor=white)

**A Professional Windows System Repair Toolkit** 🚀

*Safely Repair Windows Services, Update Systems, And Network Issues With Confidence*

[![GitHub Repository](https://img.shields.io/badge/Repository-Safe--Windows--Repair-blue?style=flat-square&logo=github)](https://github.com/i8o8i-Developer/Safe-Windows-Repair)

[📥 Download](#installation) • [📖 Usage](#usage) • [🛠️ Features](#features) • [⚠️ Safety](#safety-precautions)

</div>

---

## 🎯 Project Description

Safe Windows Repair Is A Comprehensive Toolkit Designed To Safely Repair Common Windows Issues Through Multiple Specialized Scripts. This Toolkit Performs System Service Repairs, Windows Update Resets, Network Stack Repairs, DISM/SFC Scans, And Cleanup Operations. The Tools Help Resolve Problems Related To Windows Updates, System File Corruption, Background Services, And Network Connectivity Without Risking System Instability.

> 💡 **Pro Tip**: Always Create A System Restore Point Before Running Any System Repair Tools.

---

## ✨ Features

- **🔄 Advanced Service Repair**: Safely Stops And Restarts Critical Windows Services Including Windows Update (wuauserv), BITS, Delivery Optimization (DoSvc), Cryptographic Services (cryptSvc), And Windows Installer (msiserver).
- **🗑️ System Cleanup**: Clears Windows Update Cache (SoftwareDistribution), Temporary Files, User Temp Folders, And System Temp Directories.
- **🛠️ System Integrity Scans**: Runs DISM RestoreHealth And SFC /Scannow To Repair System Files And Windows Image.
- **🌐 Network Stack Reset**: Performs Winsock Reset, TCP/IP Stack Reset, And DNS Flush To Fix Network Connectivity Issues.
- **💾 Automatic Backup**: Creates Timestamped Backups Of Critical Folders Before Modifications (Stored In %TEMP%\SafeWindowsRepairBackups).
- **📝 Comprehensive Logging**: Detailed Timestamped Logging Of All Operations With Color-Coded Console Output And Persistent Log Files.
- **🔐 Administrator Checks**: Ensures All Scripts Run With Appropriate Administrative Privileges.
- **🧹 Cleanup Utility**: Dedicated Batch Script To Remove All Generated Backup Files And Logs.
- **⚡ Update Reset Tool**: Specialized Script (FIX_UPDATE.BAT) For Complete Windows Update Service Reset And Cache Clearing.
- **🎯 User Confirmation**: Interactive Prompts Before Executing System-Modifying Operations.
- **🔄 Optional Reboot**: Provides User Choice To Reboot System After Repairs.
- **⚠️ Error Handling**: Robust Error Handling With Informative Messages And Graceful Degradation.
- **🎨 Pascal Case Formatting**: Consistent Professional Formatting Throughout All Scripts And Documentation.

---

## 📋 Requirements

| Component | Specification |
|-----------|---------------|
| 🖥️ **Operating System** | Windows 10/11 (64-Bit Recommended) |
| 👑 **Privileges** | Administrator Rights Required |
| 💻 **PowerShell** | PowerShell 5.1 Or Higher (Included With Windows) |
| 🔓 **Execution Policy** | Must Allow Script Execution (Temporarily Bypassed During Run) |

---

## 📥 Installation

1. 📦 Download All Files From The Repository.
2. 📂 Extract To A Folder On Your Local Machine.
3. 👑 Ensure You Have Administrator Privileges.

```bash
# Example Extraction Command
Expand-Archive -Path "SafeWindowsRepair.zip" -DestinationPath "C:\Tools\SafeWindowsRepair"
```

---

## 🚀 Usage

### Running The Main Repair Script (SafeWindowsRepair.ps1)

1. 👑 Right-Click PowerShell And Select **Run As Administrator**.
2. 📂 Navigate To The Folder Containing The Scripts.
3. ▶️ Execute The Following Commands:

```powershell
# Set Execution Policy (One-Time Per Session)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run The Repair Script
.\SafeWindowsRepair.ps1
```

4. ✅ Type **YES** When Prompted To Confirm Repair Operations.
5. 👀 Monitor The Color-Coded Console Output (Green=Info, Yellow=Warning, Red=Error, Cyan=Debug).
6. 🔄 Choose Whether To Reboot When Prompted After Completion.
7. 📄 Review The Generated Timestamped Log File (e.g., `SafeWindowsRepair_20251114_103000.log`) For Details.

### Alternative: Quick Launch Using Important.txt Instructions

1. 👑 Open PowerShell As Administrator.
2. 📂 Navigate To The Script Directory.
3. ▶️ Run The Commands Listed In `Important.txt`:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\SafeWindowsRepair.ps1
```

### Running The Windows Update Reset Script (FIX_UPDATE.BAT)

1. 👑 Right-Click `FIX_UPDATE.BAT` And Select **Run As Administrator**.
2. ⏳ Wait For The Script To Complete The Following:
   - Stop Windows Update Services (wuauserv, cryptSvc, BITS, msiserver)
   - Clear BITS Job Queue
   - Delete Update Cache And Logs
   - Rename SoftwareDistribution And catroot2 Folders
   - Restart Windows Update Services
3. ✅ Press Any Key When Complete.

### 🧹 Cleaning Up Backups And Logs

After Running Repair Scripts, Use The Cleanup Utility:

1. 👑 Right-Click `Remove-SafeRepairBackups.bat` And Select **Run As Administrator**.
2. 🔄 The Script Will Automatically:
   - Delete All Backup Files (*.bak)
   - Remove Log Files (SafeWindowsRepair.log)
   - Clean Temp Directories Created By Repair Operations
3. ✅ Review The Completion Message And Press Any Key To Exit.

---

## 📁 File Descriptions

| File | Description | Icon |
|------|-------------|------|
| `SafeWindowsRepair.ps1` | Main PowerShell Script That Performs Comprehensive System Repairs: Service Management, Temp Cleanup, SoftwareDistribution Cache Reset, DISM RestoreHealth, SFC Scannow, And Network Stack Reset. Includes Automatic Backup, Timestamped Logging, And Optional Reboot. | 🔧 |
| `FIX_UPDATE.BAT` | Specialized Batch Script For Complete Windows Update Reset. Stops Update Services, Cleans BITS Queue, Deletes Update Cache And Logs, Renames SoftwareDistribution And catroot2 Folders, Then Restarts Services. Ideal For Fixing Stubborn Update Problems. | ⚡ |
| `Remove-SafeRepairBackups.bat` | Cleanup Utility That Removes All Backup Files (*.bak), Log Files (SafeWindowsRepair*.log), And Temporary Directories Created During Repair Operations. | 🧹 |
| `Important.txt` | Quick Reference File Containing Essential Commands To Run SafeWindowsRepair.ps1 With Proper Execution Policy Bypass. | 📝 |
| `SafeWindowsRepair_*.log` | Timestamped Log Files Generated During Script Execution Containing Detailed Operation History With Timestamps And Status Levels (INFO, WARN, ERROR, DEBUG). | 📄 |
| `LICENSE` | MIT License File Covering Usage Terms And Conditions. | ⚖️ |
| `README.md` | This Documentation File Providing Complete Guide To The Toolkit. | 📖 |

---

## 🔧 Services Repaired

The Scripts Target The Following Essential Windows Services:

### SafeWindowsRepair.ps1 Services

| Service Name | Display Name | Purpose |
|--------------|--------------|---------|
| `wuauserv` | Windows Update Service | Manages Windows Updates And Update Detection |
| `BITS` | Background Intelligent Transfer Service | Transfers Files In Background Using Idle Network Bandwidth |
| `DoSvc` | Delivery Optimization Service | Optimizes Windows Update And App Delivery |

### FIX_UPDATE.BAT Services

| Service Name | Display Name | Purpose |
|--------------|--------------|---------|
| `wuauserv` | Windows Update Service | Manages Windows Updates |
| `cryptSvc` | Cryptographic Services | Provides Cryptographic Operations And Certificate Management |
| `bits` | Background Intelligent Transfer Service | Manages Background File Transfers |
| `msiserver` | Windows Installer Service | Manages Software Installation And Removal |

---

## 🌐 System Repair Operations

### SafeWindowsRepair.ps1 Operations

The Main Script Performs The Following Comprehensive Repairs:

#### 1. **Service Management** 🔄
- Safely Stops Critical Windows Services (wuauserv, BITS, DoSvc)
- Monitors Service Status With Configurable Timeouts (20-30 Seconds)
- Automatically Restarts Services After Repairs

#### 2. **Backup Creation** 💾
- Creates Timestamped Backups Of SoftwareDistribution Folder
- Stores Backups In `%TEMP%\SafeWindowsRepairBackups`
- Backup Format: `FolderName_Backup_YYYYMMDD_HHMMSS`

#### 3. **System Cleanup** 🗑️
- Clears `C:\Windows\SoftwareDistribution` (Windows Update Cache)
- Cleans `%LOCALAPPDATA%\Temp` (User Temp Folder)
- Clears `%SystemRoot%\Temp` (System Temp Folder)
- Removes Windows Update DataStore Files

#### 4. **System Integrity Checks** 🛠️
- **DISM RestoreHealth**: Repairs Windows Image Using Windows Update
- **SFC /Scannow**: Scans And Repairs Protected System Files

#### 5. **Network Stack Reset** 🌐
- **Winsock Reset**: Resets Windows Sockets API (`netsh winsock reset`)
- **TCP/IP Reset**: Resets TCP/IP Protocol Stack (`netsh int ip reset`)
- **DNS Flush**: Clears DNS Resolver Cache (`ipconfig /flushdns`)

### FIX_UPDATE.BAT Operations

This Specialized Script Focuses On Complete Windows Update Reset:

#### 1. **Service Termination** 🛑
- Stops wuauserv, cryptSvc, BITS, msiserver Services

#### 2. **BITS Queue Cleanup** 🧹
- Resets All Background Intelligent Transfer Jobs (`bitsadmin /reset /allusers`)

#### 3. **Cache And Log Deletion** 🗑️
- Deletes `%windir%\SoftwareDistribution\Download\*`
- Deletes `%windir%\SoftwareDistribution\DataStore\*`
- Deletes `C:\Windows\SoftwareDistribution\DeliveryOptimization\*`
- Deletes `C:\Windows\Logs\WindowsUpdate\*`

#### 4. **Folder Renaming** 📁
- Renames `SoftwareDistribution` To `SoftwareDistribution.old`
- Renames `catroot2` To `catroot2.old`
- Forces Windows To Recreate These Folders On Service Restart

#### 5. **Service Restart** ♻️
- Restarts All Windows Update Services To Fresh State

---

## ⚙️ Configuration

The SafeWindowsRepair.ps1 Script Can Be Configured By Editing Variables And Parameters:

### Service Configuration

```powershell
# Array Of Services To Stop/Start During Repair
$ServicesToStop = @(
    'wuauserv',     # Windows Update
    'BITS',         # Background Intelligent Transfer
    'DoSvc'         # Delivery Optimization (Optional)
)
```

### Timeout Settings

```powershell
# Service Stop Timeout (Default: 25 Seconds)
Stop-ServiceSafe -ServiceName $Svc -TimeoutSeconds 25

# Service Start Timeout (Default: 30 Seconds)
Start-ServiceSafe -ServiceName $Svc -TimeoutSeconds 30
```

### Backup Location

```powershell
# Default Backup Root Directory
$BackupRoot = "$env:TEMP\SafeWindowsRepairBackups"
```

### Logging

```powershell
# Log File Naming Format
$LogFileName = "SafeWindowsRepair_${TimeStamp}.log"

# Timestamp Format
$TimeStamp = (Get-Date).ToString('yyyyMMdd_HHmmss')

# Log Levels: INFO, WARN, ERROR, DEBUG
Write-Log "Message" "INFO"
```

### Paths To Clean

```powershell
# User Temporary Files
$UserTemp = "$env:LOCALAPPDATA\Temp"

# System Temporary Files
$SystemTemp = "$env:SystemRoot\Temp"

# Windows Update Cache
$SoftwareDistribution = 'C:\Windows\SoftwareDistribution'
```

---

## 🛡️ Safety Precautions

> ⚠️ **Important**: These Tools Modify System Services, Windows Update Cache, And Network Settings. Use With Caution!

### Before Running

- 💾 **Create System Restore Point**: Use Windows System Restore To Create A Restore Point Before Running Any Repairs.
- 📦 **Backup Important Data**: Always Backup Critical Files And Documents.
- 🔌 **Save Your Work**: Close All Applications And Save Any Open Work.
- 📶 **Network Awareness**: Network Repairs Will Temporarily Disconnect Internet Connectivity.

### During Execution

- 👑 **Administrator Rights**: All Scripts Must Be Run As Administrator.
- ⏳ **Be Patient**: DISM And SFC Operations Can Take 10-30 Minutes To Complete.
- 🚫 **Don't Interrupt**: Allow Scripts To Complete Without Interruption.
- 👀 **Monitor Output**: Watch Console Messages For Any Errors Or Warnings.

### After Execution

- 📄 **Review Logs**: Check Timestamped Log Files For Any Errors Or Warnings.
- 🔄 **Reboot Recommended**: Restart Your System To Apply All Changes Fully.
- ✅ **Verify Functionality**: Test Windows Update And Network Connectivity.
- 🧹 **Clean Backups**: Use Remove-SafeRepairBackups.bat After Confirming System Stability.

### Understanding Script Behavior

- ✅ **Non-Destructive**: SafeWindowsRepair.ps1 Creates Backups Before Modifications.
- ⚡ **Aggressive Reset**: FIX_UPDATE.BAT Performs More Aggressive Update Cache Clearing.
- 🎯 **User Confirmation**: SafeWindowsRepair.ps1 Requires "YES" Confirmation Before Proceeding.
- 🔄 **Service Recovery**: Services Are Automatically Restarted After Repairs.

### Advanced Users

- 🧪 **Test In VM**: Consider Testing In A Virtual Machine First.
- 📝 **Script Customization**: Modify Service Lists And Timeouts As Needed.
- 🔍 **DISM Logs**: Review DISM Logs At `C:\Windows\Logs\DISM\dism.log` For Details.
- 📊 **SFC Logs**: Check SFC Results At `C:\Windows\Logs\CBS\CBS.log`.

---

## 🔍 Troubleshooting

### Common Issues

| Issue | Solution | Status |
|-------|----------|--------|
| **Execution Policy Error** | Run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` In PowerShell As Administrator | 🔧 |
| **Access Denied** | Right-Click Script And Select "Run As Administrator" | 👑 |
| **Service Not Found** | Some Services (DoSvc) May Not Exist On Older Windows Versions - Script Will Continue | ℹ️ |
| **DISM Takes Too Long** | DISM RestoreHealth Can Take 15-30 Minutes - Be Patient And Don't Interrupt | ⏳ |
| **SFC Cannot Repair Files** | Run DISM First, Then Run SFC Again - Some Repairs Require Multiple Passes | 🔄 |
| **Network Issues Persist After Reset** | Restart System After Network Repairs - Full Reset Requires Reboot | 🔄 |
| **Windows Update Still Failing** | Run FIX_UPDATE.BAT For More Aggressive Update Reset, Then Reboot | ⚡ |
| **Backup Folder Filling Disk** | Run Remove-SafeRepairBackups.bat To Clean Up Old Backups | 🧹 |
| **Script Stops Unexpectedly** | Check Log Files For Error Messages - May Need To Manually Restart Services | 📄 |

### 📊 Log Analysis

Check Timestamped Log Files For Detailed Error Messages And Operation Status:

#### SafeWindowsRepair.ps1 Logs

```
2025-11-14 10:30:00 [INFO] SafeWindowsRepair Started. Log: C:\Path\SafeWindowsRepair_20251114_103000.log
2025-11-14 10:30:01 [DEBUG] Confirmed Running As Administrator.
2025-11-14 10:30:02 [INFO] Stopping Service wuauserv...
2025-11-14 10:30:03 [INFO] Service wuauserv Stopped.
2025-11-14 10:30:04 [INFO] Backing Up C:\Windows\SoftwareDistribution To %TEMP%\SafeWindowsRepairBackups\...
2025-11-14 10:30:15 [INFO] Clearing Contents Of C:\Windows\SoftwareDistribution ...
2025-11-14 10:35:00 [INFO] Running DISM Restore-Health (This Can Take Some Minutes)...
2025-11-14 10:50:00 [INFO] DISM Completed Successfully.
2025-11-14 10:50:01 [INFO] Running sfc /scannow...
2025-11-14 11:05:00 [INFO] SFC Completed (ExitCode 0).
2025-11-14 11:05:01 [INFO] Resetting Winsock And TCP/IP Stack, Flushing DNS...
2025-11-14 11:05:02 [INFO] Network Stack Reset Commands Executed. A Reboot May Be Required For Full Effect.
2025-11-14 11:05:03 [INFO] Starting Service wuauserv...
2025-11-14 11:05:05 [INFO] Service wuauserv Started.
2025-11-14 11:05:06 [INFO] All Operations Complete. Review The Log At C:\Path\SafeWindowsRepair_20251114_103000.log.
```

#### Log Level Meanings

- **[INFO]**: Normal Operations And Successful Actions (Green)
- **[WARN]**: Non-Critical Issues That Don't Stop Execution (Yellow)
- **[ERROR]**: Critical Failures That May Impact Functionality (Red)
- **[DEBUG]**: Detailed Technical Information For Troubleshooting (Cyan)

### 🔧 Manual Service Recovery

If Services Fail To Restart Automatically:

```powershell
# Manually Start Windows Update Services
net start wuauserv
net start BITS
net start DoSvc
net start cryptSvc
net start msiserver
```

### 🌐 Network Connectivity Issues

If Network Problems Persist After Repair:

```powershell
# Additional Network Reset Commands
netsh int tcp reset
netsh advfirewall reset
ipconfig /release
ipconfig /renew
ipconfig /registerdns
```

### 📁 Checking DISM And SFC Results

```powershell
# View DISM Log
notepad C:\Windows\Logs\DISM\dism.log

# View SFC Log (Last 50 Lines)
Get-Content C:\Windows\Logs\CBS\CBS.log | Select-Object -Last 50
```

---

## 👤 Author

**Durgai Solutions** 🏢

*Professional Windows System Administration Tools*

**GitHub**: [@i8o8i-Developer](https://github.com/i8o8i-Developer) 👨‍💻

**Repository**: [Safe-Windows-Repair](https://github.com/i8o8i-Developer/Safe-Windows-Repair) 📂

---

## 📄 License

This Project Is Licensed Under The MIT License. See The [LICENSE](LICENSE) File For Full Details.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

### 📋 MIT License Summary

- ✅ **Permissive**: Allows Commercial Use, Modification, Distribution, And Private Use
- ✅ **No Copyleft**: Derivative Works Can Be Licensed Under Different Terms
- ⚠️ **Liability**: Software Provided "As Is" Without Warranty
- 📄 **Requirements**: Copyright Notice And Permission Notice Must Be Included

**Full License Text Available In [LICENSE](LICENSE) File**

---

## 📈 Version History

| Version | Date | Changes |
|---------|------|---------|
| **V1.0** | 2025-11-14 | Initial Release With SafeWindowsRepair.ps1 (Comprehensive System Repair), FIX_UPDATE.BAT (Update Reset), And Remove-SafeRepairBackups.bat (Cleanup Utility) |

---

## 💬 Support

For Issues, Questions, Or Feature Requests:

- 📄 **Check Logs**: Review Timestamped Log Files For Detailed Error Information
- 🔍 **Troubleshooting Guide**: Review The Troubleshooting Section Above For Common Solutions
- 📚 **Documentation**: Read Through File Descriptions And Configuration Sections
- 🐛 **Report Issues**: Provide Detailed Log Information When Reporting Problems

### Useful Information To Include When Reporting Issues

- 🪟 Windows Version (Run `winver` Command)
- 📝 Complete Log File Contents
- 🔧 Which Script Was Used (SafeWindowsRepair.ps1 Or FIX_UPDATE.BAT)
- ❌ Exact Error Messages Received
- 🔄 Steps Taken Before Error Occurred

This Tool Is Provided Without Formal Support Channels But Aims For Maximum Self-Service Troubleshooting.

---

<div align="center">

**Made With ❤️ By Durgai Solutions**

**GitHub**: [@i8o8i-Developer](https://github.com/i8o8i-Developer) • **Repository**: [Safe-Windows-Repair](https://github.com/i8o8i-Developer/Safe-Windows-Repair)

---

**⚠️ Disclaimer**: These Tools Modify System Services, Windows Update Cache, And Network Settings. While Designed To Be Safe And Include Backup Mechanisms, Always Create A System Restore Point And Backup Important Data Before Proceeding. Use At Your Own Risk.

</div>