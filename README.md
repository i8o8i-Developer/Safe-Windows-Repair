# 🔧 Safe Windows Repair

<div align="center">

![Windows Logo](https://img.shields.io/badge/Windows-0078D4?style=for-the-badge&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![GitHub](https://img.shields.io/badge/GitHub-i8o8i--Developer-181717?style=for-the-badge&logo=github&logoColor=white)

**A Professional Windows System Repair Toolkit** 🚀

*Safely Repair Windows Services And Network Issues With Confidence*

[![GitHub Repository](https://img.shields.io/badge/Repository-Safe--Windows--Repair-blue?style=flat-square&logo=github)](https://github.com/i8o8i-Developer/Safe-Windows-Repair)

[📥 Download](#installation) • [📖 Usage](#usage) • [🛠️ Features](#features) • [⚠️ Safety](#safety-precautions)

</div>

---

## 🎯 Project Description

Safe Windows Repair Is A Comprehensive Toolkit Designed To Safely Repair Common Windows Issues By Restarting Essential System Services And Performing Network Repair Operations. This Tool Helps Resolve Problems Related To Windows Updates, Background Services, And Network Connectivity Without Risking System Instability.

> 💡 **Pro Tip**: Always Create A System Restore Point Before Running Any System Repair Tools.

---

## ✨ Features

- **🔄 Service Repair**: Safely Stops And Restarts Critical Windows Services Including Windows Update, BITS, Trusted Installer, Cryptographic Services, And Windows Installer.
- **🌐 Network Repair**: Performs Complete Network Stack Reset Including Winsock Reset, TCP/IP Reset, DNS Flush And Registration, DHCP Lease Renewal, And Network Service Restart.
- **📝 Logging**: Comprehensive Logging Of All Operations With Timestamps And Status Messages.
- **👑 Administrator Checks**: Ensures Scripts Run With Appropriate Privileges.
- **🧹 Backup Cleanup**: Includes Utility To Remove Generated Backup And Log Files.
- **⚠️ Error Handling**: Robust Error Handling With Informative Messages.
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

### Running The Repair Script

1. 💻 Open Command Prompt Or PowerShell As Administrator.
2. 📂 Navigate To The Folder Containing The Scripts.
3. ▶️ Execute The Following Commands:

```powershell
# Set Execution Policy (One-Time Per Session)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Run The Repair Script
.\SafeWindowsRepair.ps1
```

4. 👀 Follow The On-Screen Instructions And Wait For Completion.
5. 📄 Review The Generated Log File (`SafeWindowsRepair.log`) For Details.

### 🧹 Cleaning Up Backups

After Running The Repair Script, Use The Cleanup Utility:

1. ▶️ Run `Remove-SafeRepairBackups.bat` As Administrator.
2. 🔄 The Script Will Automatically Remove All Backup Files, Logs, And Temporary Directories.

---

## 📁 File Descriptions

| File | Description | Icon |
|------|-------------|------|
| `SafeWindowsRepair.ps1` | Main PowerShell Script That Performs Service And Network Repairs | 🔧 |
| `Remove-SafeRepairBackups.bat` | Batch File To Clean Up Generated Backup And Log Files | 🧹 |
| `Important.txt` | Quick Start Instructions For Running The Repair Script | 📝 |
| `SafeWindowsRepair.log` | Generated Log File Containing Detailed Operation History | 📄 |

---

## 🔧 Services Repaired

The Script Targets The Following Essential Windows Services:

| Service | Display Name | Purpose |
|---------|--------------|---------|
| `wuauserv` | Windows Update Service | Manages Windows Updates |
| `bits` | Background Intelligent Transfer Service | Transfers Files In Background |
| `TrustedInstaller` | Windows Modules Installer | Installs Windows Updates |
| `cryptsvc` | Cryptographic Service | Provides Cryptographic Services |
| `msiserver` | Windows Installer Service | Manages Windows Installer |

---

## 🌐 Network Repair Operations

When Network Repair Is Enabled, The Script Performs:

- 🔄 **Winsock Reset**: Resets Windows Sockets API
- 🌐 **TCP/IP Stack Reset**: Resets TCP/IP Protocol Stack
- 🧹 **DNS Cache Flush**: Clears DNS Resolver Cache
- 📝 **DNS Registration**: Registers DNS Names
- 🔄 **DHCP Lease Renewal**: Releases And Renews IP Address Lease
- ⚡ **Network Services Restart**: Restarts DHCP, DNS Client, Network Location Awareness, And Network Connections

---

## ⚙️ Configuration

The Script Can Be Configured By Editing Variables At The Top Of `SafeWindowsRepair.ps1`:

```powershell
# Array Of Services To Process
$ServicesToRepair = @("wuauserv", "bits", "TrustedInstaller", "cryptsvc", "msiserver")

# Toggle Network Repair Operations
$PerformNetworkRepair = $True

# Delay Between Service Operations (Milliseconds)
$SleepBetweenActionsMs = 500

# Timeout For Network Commands (Seconds)
$NetworkCommandTimeoutSec = 60
```

---

## 🛡️ Safety Precautions

> ⚠️ **Important**: This Tool Modifies System Services And Network Settings. Use With Caution!

- 💾 **Backup Important Data**: Always Backup Critical Files Before Running System Repairs.
- 👑 **Administrator Mode**: Scripts Must Be Run As Administrator.
- 🌐 **Network Disruption**: Network Repair May Temporarily Disconnect Internet Connectivity.
- 🔄 **System Restart**: Some Changes May Require A System Restart To Take Effect.
- 🧪 **Test Environment**: Consider Testing In A Virtual Machine First.
- 📝 **Log Review**: Always Check The Generated Log File For Any Errors Or Warnings.

---

## 🔍 Troubleshooting

### Common Issues

| Issue | Solution | Status |
|-------|----------|--------|
| **Execution Policy Error** | Run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` First | 🔧 |
| **Access Denied** | Ensure You Are Running As Administrator | 👑 |
| **Service Not Found** | Some Services May Not Exist On Certain Windows Versions | ℹ️ |
| **Network Issues Persist** | Try Restarting The System After Repair | 🔄 |

### 📊 Log Analysis

Check `SafeWindowsRepair.log` For Detailed Error Messages And Operation Status:

```
2025-11-11 10:30:00 [INFO] Beginning Safe Windows Repair Process.
2025-11-11 10:30:01 [INFO] Processing Service: wuauserv
2025-11-11 10:30:02 [INFO] Stopped Service: wuauserv
...
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
| **V1.0** | 2025-11-11 | Initial Release With Service And Network Repair Capabilities |

---

## 💬 Support

For Issues Or Questions:

- 📄 Check The Log Files And Ensure All Prerequisites Are Met
- 🔍 Review The Troubleshooting Section Above
- 🐛 Report Issues With Detailed Log Information

This Tool Is Provided Without Formal Support Channels.

---

<div align="center">

**Made With ❤️ By Durgai Solutions**

**GitHub**: [@i8o8i-Developer](https://github.com/i8o8i-Developer) • **Repository**: [Safe-Windows-Repair](https://github.com/i8o8i-Developer/Safe-Windows-Repair)

---

**⚠️ Disclaimer**: This Tool Modifies System Services And Network Settings. While Designed To Be Safe, Use Caution And Backup Your System Before Proceeding.

</div>