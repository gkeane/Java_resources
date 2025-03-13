# KACE Embedded Java Discovery Setup

## Overview
This guide details the deployment of scripts to discover embedded Java installations across your environment using KACE Systems Management Appliance (SMA).

## Prerequisites
- KACE SMA Administrator access
- PowerShell execution enabled on target systems
- Write access to `C:\ProgramData\Quest\KACE\user\` on endpoints

## Deployment Steps

### 1. Create the Discovery Script
1. Navigate to **Scripts > Script Library**
2. Click **New Script**
3. Configure the script:
   ```
   Name: Embedded Java Discovery
   Type: Online KScript
   Enabled: Yes
   Deploy: After check-in
   Windows Run As: Local System
   Upload java_location.ps1
   ```
4. Set schedule:
   - Run every: 1 week
   - Start time: Off-hours
   - Target specific labels if needed

### 2. Configure Custom Inventory Rule
1. Navigate to **Inventory > Software > Custom Inventory Rules**
2. Click **Choose Action > New**
3. Configure the rule:
   ```
   Name: CI-Java_location
   Type: PowerShell
   Upload CI-java_installations.ps1
   Return Type: String (Text)
   ```
4. Click **Save**

### 3. Monitor Deployment
1. Check script status:
   - Navigate to **Script > Script Log**
   - Filter for "Embedded Java Discovery"
   - Review completion status

2. Verify data collection:
   - Navigate to **Assets > Devices**
   - Select a device
   - Check Custom Inventory section
   - Look for "Embedded Java Inventory" entry

### 4. Create Custom Reports
1. Navigate to **Reporting > Reports**
2. Click **New Report**
3. Create the following reports using the SQL from `KACE_EMBEDDED_REPORTS.sql`:

#### Basic Java Inventory Report
- **Name**: Basic Java Inventory
- **Category**: Inventory
- **Description**: Lists all machines with their Java installations
- **SQL**: Use the first query from KACE_EMBEDDED_REPORTS.sql

#### Detailed Java Installations Report
- **Name**: Detailed Java Installations
- **Category**: Inventory
- **Description**: Shows detailed breakdown of each Java installation
- **SQL**: Use the second query from KACE_EMBEDDED_REPORTS.sql

#### Java Version Summary Report
- **Name**: Java Version Summary
- **Category**: Inventory
- **Description**: Summarizes Java versions across the environment
- **SQL**: Use the third query from KACE_EMBEDDED_REPORTS.sql

#### Missing Java Scan Report
- **Name**: Missing Java Scans
- **Category**: Inventory
- **Description**: Shows machines where Java scanning is incomplete
- **SQL**: Use the fourth query from KACE_EMBEDDED_REPORTS.sql

4. For each report:
   - Set **Schedule**: As needed
   - **Permissions**: Assign as appropriate
   - **Email**: Configure notifications if desired

### 5. Troubleshooting
- Check progress log: `