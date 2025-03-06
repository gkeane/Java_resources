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
PowerShell script for Windows systems to handle Java 8 uninstallation.
*(File contents not provided in the current context)*

### 3. Java8UninstallEffort.bat
Batch script for Windows systems to handle Java 8 uninstallation.
*(File contents not provided in the current context)*

### 4. jamf_removal.sh
Shell script for macOS systems managed by Jamf to handle Java 8 uninstallation.
*(File contents not provided in the current context)*

