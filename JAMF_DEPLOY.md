# JAMF Pro Deployment Guide - Java 8 Removal

This guide provides step-by-step instructions for implementing a phased Java 8 removal using JAMF Pro.

## Script Upload

### Add Script to JAMF Pro
1. Navigate to **Settings > Computer Management > Scripts**
2. Click **+ New**
3. Configure script settings:
   - **Display Name**: Java 8 Removal Script
   - **Category**: Scripts
   - **Information**: Removes Java 8 and related components
   - **Script Contents**: Copy contents of `jamf_removal.sh`
   - **Script Priority**: After
   - **Parameter Labels**: None required

## Smart Group Configuration

### Create Base Smart Group
1. Navigate to **Computers > Smart Computer Groups**
2. Click **+ New**
3. Configure base group:
   - **Display Name**: Java 8 Installed
   - **Site**: All Sites (or as needed)
   - Add criteria:
     - Extension Attribute > OracleJavaVersion > is not blank
     - and
     - Operating System > like > macOS

### Create Phased Rollout Group
1. Create a static group for controlled deployment:
   - Navigate to **Computers > Static Computer Groups**
   - Click **+ New**
   - **Display Name**: Java 8 Removal - Controlled Rollout
   - **Site**: All Sites (or as needed)

2. Add computers gradually:
   - Select computers from "Java 8 Installed" smart group
   - Add small batches to the static group
   - Monitor results before adding more systems

## Policy Creation

### Create Removal Policy
1. Navigate to **Computers > Policies**
2. Click **+ New**
3. Configure policy:
   - **General**
     - Display Name: Java 8 Removal
     - Enabled: Yes
     - Category: Scripts
     - Trigger: Recurring Check-in
     - Execution Frequency: Once per week

   - **Scope**
     - Target: Your phased smart groups
     - Exclusions: As needed

   - **Scripts**
     - Add the Java 8 Removal script
     - Priority: After


## Monitoring

### Deployment Status
1. Navigate to **Computers > Policies**
2. Select Java 8 Removal policy
3. View:
   - Completion Status
   - Failed Deployments
   - Pending Executions

### CrowdStrike FQL Monitoring
1. Use the following FQL query to monitor Java executions (last 7 days):
   ```sql
   (#event_simpleName = ProcessRollup2 or #ecs.version = *) |
   (CommandLine !="*/java_home") AND
   (CommandLine !="./javasettings") AND
   (CommandLine = "*java*") and
   (event_platform = "Mac") and
   (CommandLine != "*find*") AND
   (CommandLine != "*Updater*") AND
   (CommandLine != "*Plugin*")
   | tail(1000)
   ```
   
   This query will:
   - Show Java process executions on Mac systems
   - Exclude common false positives
   - Display up to 1000 most recent entries
   - Help identify systems still using Java after removal

2. Monitor results to:
   - Identify non-compliant systems
   - Detect unauthorized Java installations
   - Validate removal success

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

## Troubleshooting

### Common Issues
1. **Script Execution Failures**
   - Check JAMF Pro logs
   - Verify target machine connectivity
   - Check permissions

2. **Java Still Present**
   - Run manual inventory update
   - Check for multiple Java versions
   - Review script logs

### Log Collection
- Policy logs: /var/log/jamf.log
- Script logs: As defined in script
- System logs: Console.app

## Emergency Procedures

### Stop Deployment
1. Navigate to **Computers > Policies**
2. Select Java 8 Removal policy
3. Click **Disable**

### Rollback Options
- Keep policy disabled
- Remove smart group scope
- Document affected systems 