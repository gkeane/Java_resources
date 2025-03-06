# 64Bit Installs:

# Get list of installed software from the registry
$installedSoftware = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue | Select-Object DisplayName, UninstallString

# Filter out entries without a DisplayName
$installedSoftware = $installedSoftware | Where-Object { $_.DisplayName -ne $null }

# Find the entry for "Java 8"
$java8 = $installedSoftware | Where-Object { $_.DisplayName -like "*Java 8*" }


# Output the list of installed software with uninstall command
$currentDateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$currentDateTime | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString

if ($java8) {
    # Run the uninstall command
    Write-Output "Uninstalling Java 8..."
    $java8.UninstallString +" /qn" | Out-File -FilePath C:\ProgramData\Quest\KACE\user\uninstall.bat -Encoding ascii
    $filePath = "C:\ProgramData\Quest\KACE\user\uninstall.bat"
    $content = Get-Content -Path $filePath
    $updatedContent = $content -replace "MsiExec\.exe /I", "MsiExec.exe /X"
    Set-Content -Path $filePath -Value $updatedContent
    & C:\ProgramData\Quest\KACE\user\uninstall.bat

} else {
    Write-Output "Java 8 64Bit is not installed on this system." 
    Write-Output "Java 8 64Bit is not installed on this system." | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
}

$installedSoftware = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue | Select-Object DisplayName, UninstallString
$installedSoftware = $installedSoftware | Where-Object { $_.DisplayName -ne $null }
$java8 = $installedSoftware | Where-Object { $_.DisplayName -like "*Java 8*" }

$currentDateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$currentDateTime | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString

#type C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log

$file = "C:\ProgramData\Quest\KACE\user\uninstall.bat"
if (Test-Path -Path $file) {
    Remove-Item -Path $file -Force
    Write-Output "File deleted: $file"
} else {
    Write-Output "File does not exist: $file"
}


# 32Bit Installs:

# Get list of installed software from the registry
$installedSoftware = Get-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue | Select-Object DisplayName, UninstallString

# Filter out entries without a DisplayName
$installedSoftware = $installedSoftware | Where-Object { $_.DisplayName -ne $null }

# Find the entry for "Java 8"
$java8 = $installedSoftware | Where-Object { $_.DisplayName -like "*Java 8*" }


# Output the list of installed software with uninstall command
$currentDateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$currentDateTime | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString

if ($java8) {
    # Run the uninstall command
    Write-Output "Uninstalling Java 8..."
    $java8.UninstallString +" /qn" | Out-File -FilePath C:\ProgramData\Quest\KACE\user\uninstall.bat -Encoding ascii
    $filePath = "C:\ProgramData\Quest\KACE\user\uninstall.bat"
    $content = Get-Content -Path $filePath
    $updatedContent = $content -replace "MsiExec\.exe /I", "MsiExec.exe /X"
    Set-Content -Path $filePath -Value $updatedContent
    & C:\ProgramData\Quest\KACE\user\uninstall.bat
} else {
    Write-Output "Java 8 32Bit is not installed on this system." 
    Write-Output "Java 8 32Bit is not installed on this system." | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
}

$installedSoftware = Get-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" -ErrorAction SilentlyContinue | Select-Object DisplayName, UninstallString
$installedSoftware = $installedSoftware | Where-Object { $_.DisplayName -ne $null }
$java8 = $installedSoftware | Where-Object { $_.DisplayName -like "*Java 8*" }

$currentDateTime = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$currentDateTime | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString | Out-File -FilePath C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log -Append
$java8 | Format-Table -Property DisplayName, UninstallString

#type C:\ProgramData\Quest\KACE\user\JavaUninstallEffort.log

$file = "C:\ProgramData\Quest\KACE\user\uninstall.bat"
if (Test-Path -Path $file) {
    Remove-Item -Path $file -Force
    Write-Output "File deleted: $file"
} else {
    Write-Output "File does not exist: $file"
}

$file2 = "C:\ProgramData\Quest\KACE\user\Java8UninstallEffort.ps1"
if (Test-Path -Path $file2) {
    Remove-Item -Path $file2 -Force
    Write-Output "File deleted: $file2"
} else {
    Write-Output "File does not exist: $file2"
}