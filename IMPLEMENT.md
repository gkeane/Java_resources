# Java Management Implementation Guide

## KACE Java 8 Removal
### Setup
1. Deploy `Java8UninstallEffort.ps1` via KACE script:
   - Upload both .ps1 and .bat files
   - Set to run as System
   - Schedule according to rollout plan

### Phased Rollout
1. Create static group for controlled deployment:
   - Navigate to **Computers > Static Computer Groups**
   - Click **+ New**
   - **Display Name**: Java 8 Removal - Controlled Rollout
   - **Site**: All Sites (or as needed)

2. Add computers gradually:
   - Select computers from "Java 8 Installed" smart group
   - Add small batches to the static group
   - Monitor results before adding more systems

### Monitoring
1. Navigate to **Computers > Policies**
2. Select Java 8 Removal policy
3. View:
   - Completion Status
   - Failed Deployments
   - Pending Executions

### Extension Attribute Reporting
1. Navigate to **Advanced Searches**
2. Create new search:
   - **Display Name**: Java 8 Status Report
   - Add criteria:
     - Extension Attribute > OracleJavaVersion > is not blank
3. Save and run report to:
   - Track remaining Java 8 installations
   - Export results for stakeholder updates
   - Monitor deployment progress

## JAMF Java 8 Removal
### Setup
1. Upload `jamf_removal.sh` to JAMF
2. Configure policy:
   - Priority: High
   - Execution: During check-in
   - Target: All managed Macs

### Verification
- Script logs to system.log
- Removes:
  - Java plugins
  - Control panels
  - System preferences
  - Cache files

## Java Discovery Tools
### Prerequisites
- KACE SMA Administrator access
- PowerShell execution enabled
- Write access to `C:\ProgramData\Quest\KACE\user\`

### Discovery Script Deployment
1. Create scheduled script:
   ```
   Name: Embedded Java Discovery
   Type: Online KScript
   Enabled: Yes
   Deploy: After check-in
   Windows Run As: Local System
   Upload java_location.ps1
   ```

### Custom Inventory Setup
1. Navigate to **Inventory > Software > Custom Inventory Rules**
2. Configure rule:
   ```
   Name: Embedded Java Inventory
   Type: Shell Command Text Return
   Command: ShellCommandTextReturn(cmd /c type c:\Programdata\Quest\KACE\user\java_installations.log)
   Return Type: String (Text)
   ```

### Reporting
1. Import queries from `KACE_EMBEDDED_REPORTS.sql`
2. Available reports:
   - Basic Java inventory
   - Detailed installation breakdown
   - Version summary
   - Missing scan report

## Support Files
- Log locations:
  - Java discovery: `C:\ProgramData\Quest\KACE\user\java_installations.log`
  - Search progress: `C:\ProgramData\Quest\KACE\user\java_search_progress.log`
  - Uninstall logs: System event log

## Troubleshooting
- Check script execution logs
- Verify file permissions
- Monitor KACE agent status
- Review SQL report results 