# KACE Deployment Guide - Java 8 Removal

This guide provides step-by-step instructions for implementing the Java 8 removal process in KACE Systems Management Appliance (SMA).

## Smart Label Implementation

### Create Smart Label
1. Navigate to **Settings > Labels > Smart Labels**
2. Click **New Smart Label**
3. Configure the following:
   - **Name**: Java 8 Removal Targets
   - **Description**: Systems eligible for Java 8 removal based on daily rollout schedule
   - **Choose Device Type**: Devices

### Smart Label SQL
Copy and paste the following query into the SQL Query field:

⚠️ **IMPORTANT**: Update the date '2024-03-01' in the query below to your desired implementation start date before deploying!

```sql
SELECT MACHINE.ID
FROM MACHINE
WHERE 
    -- Calculate days since implementation start date
    -- MODIFY THIS DATE to your implementation start date
    DATEDIFF(CURDATE(), '2024-03-01') >= (MACHINE.ID % 30) -- 30 day rollout
AND EXISTS (
    SELECT 1 
    FROM CATALOG.SAM_CATALOG 
    JOIN SAM_MACHINE_JT ON CATALOG.SAM_CATALOG.ID = SAM_MACHINE_JT.SAM_CATALOG_ID 
    WHERE MACHINE.ID = SAM_MACHINE_JT.MACHINE_ID 
    AND CATALOG.SAM_CATALOG.NAME LIKE 'Java 8 Update%'
)
```

### Implementation Date
Before deploying the Smart Label:
1. Determine your desired rollout start date
2. Replace '2024-03-01' in the SQL query with your start date
3. Use format 'YYYY-MM-DD'
4. The rollout will proceed for 30 days from this date

## Script Implementation

### Create Script
1. Navigate to **Scripting > Scripts**
2. Click **New Script**

### Basic Settings
- **Name**: Java 8 Removal Script
- **Description**: Removes Java 8 from Windows systems
- **Type**: Online KScript
- **Enabled**: Yes
- **Deploy**: After check-in
- **Run As**: Local System
- **Windows**: Yes (checked)
- **Mac**: No
- **Linux**: No

### Dependencies
Upload both script files:
- `Java8UninstallEffort.ps1`
- `Java8UninstallEffort.bat`

### Task Configuration
1. Add **Verify** step:
```batch
if not exist "C:\ProgramData\Quest\KACE\user" mkdir "C:\ProgramData\Quest\KACE\user"
```

2. Add **Remediation** step:
```batch
copy Java8UninstallEffort.ps1 "C:\ProgramData\Quest\KACE\user\" /y
copy Java8UninstallEffort.bat "C:\ProgramData\Quest\KACE\user\" /y
C:\ProgramData\Quest\KACE\user\Java8UninstallEffort.bat
```

### Schedule
- **Run every**: Day
- **At**: 10:00 AM (or your preferred maintenance window)
- **Start**: Current date
- **End**: After March 30, 2024 (or your desired end date)

### Link to Smart Label
1. In the Script settings, scroll to **Labels**
2. Add the "Java 8 Removal Targets" Smart Label
3. Click **Save**

## Monitoring

### Script Status
1. Navigate to **Scripting > Script Status**
2. Filter by "Java 8 Removal Script"
3. Review:
   - Success/failure counts
   - Individual machine results
   - Last run time

### Log Locations
- Machine logs: `C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log`
- KACE script logs: Available in Script Status details

### Smart Label Verification
1. Navigate to **Inventory > Devices**
2. Filter by "Java 8 Removal Targets" label
3. Verify systems are being added according to schedule

## Troubleshooting

### Common Issues
1. **Script Not Running**
   - Verify machine check-in status
   - Check script schedule
   - Verify Windows PowerShell is enabled

2. **Uninstall Failures**
   - Review machine logs
   - Check for administrative permissions
   - Verify Java 8 installation type
   - For stubborn installations, consider using the [Java Runtime Nuker](https://github.com/bmrf/standalone_scripts/blob/master/java_runtime_nuker.bat) script as a fallback solution

3. **Smart Label Not Updating**
   - Verify inventory updates are occurring
   - Check SQL query syntax
   - Review KACE server logs

### Fallback Solution
For systems where the standard uninstallation fails, you can deploy the Java Runtime Nuker script:
- Download [java_runtime_nuker.bat](https://github.com/bmrf/standalone_scripts/blob/master/java_runtime_nuker.bat)
- Create a new KACE script targeting problem machines
- This script performs deep cleaning of:
  - All Java Runtime versions (3-11)
  - Registry entries
  - File system remnants
  - Services and scheduled tasks
  - User profile cached files

## Emergency Stop Procedure
If needed, disable the script:
1. Navigate to **Scripting > Scripts**
2. Select "Java 8 Removal Script"
3. Uncheck "Enabled"
4. Click "Save"
