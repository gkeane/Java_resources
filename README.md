# Java 8 Removal Scripts Collection

This repository contains a collection of scripts designed to help with the phased removal of Java 8 across different platforms and management systems.

## Scripts Overview

### 1. kace_java_daily_rollout.sql
A SQL query for KACE systems management that identifies machines for phased Java 8 removal based on:
- A rolling schedule starting from March 1, 2024
- Daily incremental rollout over 30 days
- Machine selection based on Machine ID modulo
- Presence of Java 8 Updates

The query implements a daily rollout schedule where machines are selected based on their Machine ID. This ensures:
- Even distribution of machines across the 30-day period
- Approximately 1/30th of eligible machines are selected each day
- Predictable and consistent rollout pattern
- Complete coverage by March 30, 2024

### 2. Java8UninstallEffort.ps1
PowerShell script for Windows systems that:
- Checks both 32-bit and 64-bit registry locations for Java 8 installations
- Logs all actions to `C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log`
- Automatically generates and executes uninstall commands
- Uses quiet mode (/qn) for silent uninstallation
- Performs cleanup of temporary files after uninstallation
- Handles both MSI and standard installations

Key features:
- Double-pass verification of removal
- Detailed logging of all actions
- Self-cleanup after execution
- Silent operation for automated deployment

### 3. Java8UninstallEffort.bat
Batch script wrapper for the PowerShell script that:
- Copies the PS1 script to the KACE working directory
- Executes PowerShell with bypass execution policy
- Ensures proper script execution in KACE environment

### 4. jamf_removal.sh
Comprehensive shell script for macOS Java removal that:
- Removes Java browser plugins
- Removes Java control panel
- Cleans up Java installation caches
- Removes JDK/JRE installations

The script handles multiple locations:
- Browser plugins (`/Library/Internet Plug-Ins/JavaAppletPlugin.plugin`)
- System preferences (`/Library/PreferencePanes/JavaControlPanel.prefPane`)
- User caches (`~/Library/Application Support/Oracle/Java`)
- System-wide Java installations (`/Library/Java/JavaVirtualMachines`)
- Receipt files and other remnants

Features:
- Preserves OpenJDK installations
- Handles both system and user-level installations
- Provides detailed logging of removed items
- Includes superuser verification

## Prerequisites

Systems must be managed by one of the following:
- KACE Systems Management Appliance (for SQL query and Windows scripts)
- Windows PowerShell 1.0 or later (for PS1 script)
- Jamf Pro (for macOS script)
- Administrative/root privileges on target systems

## Implementation Notes

### Windows Implementation
- The PowerShell script should be deployed through KACE using the batch wrapper
- Logs are created in the KACE working directory
- Silent operation suitable for background deployment

### macOS Implementation
- Script requires root privileges (sudo)
- Preserves non-Oracle Java installations
- Can be deployed via Jamf Pro or run manually

### General Notes
- All scripts include logging for verification and troubleshooting
- Scripts are designed for silent operation in enterprise environments
- Each script includes self-cleanup functionality
- The rollout is designed to be gradual to minimize potential impact
- All scripts verify Java 8 presence before attempting removal

### Fallback Solutions
For systems where standard uninstallation methods fail, this repository includes references to additional tools:

#### Java Runtime Nuker
For Windows systems with stubborn Java installations, the [Java Runtime Nuker](https://github.com/bmrf/standalone_scripts/blob/master/java_runtime_nuker.bat) script provides comprehensive removal capabilities:
- Removes all Java Runtime versions (3-11)
- Cleans registry entries
- Removes file system remnants
- Stops and removes services
- Cleans user profile caches
- Handles both 32-bit and 64-bit installations

