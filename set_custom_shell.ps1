# This script sets your custom shell (Menu.exe) as the default Windows shell for a specific user.
# It also provides an option to restore the default shell (explorer.exe).
# Run this script as Administrator.

param(
    [string]$Username,
    [switch]$Restore
)

function Get-UserSID {
    param([string]$UserName)
    $objUser = New-Object System.Security.Principal.NTAccount($UserName)
    try {
        $strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
        return $strSID.Value
    }
    catch {
        Write-Host "Could not resolve SID for user $UserName" -ForegroundColor Red
        exit 1
    }
}

if (-not $Username) {
    Write-Host 'Please provide a username using -Username parameter.' -ForegroundColor Yellow
    exit 1
}

$userSID = Get-UserSID -UserName $Username
$regPath = "Registry::HKEY_USERS\\$userSID\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon"
# Get user profile path for dynamic shell path
$userProfile = (Get-CimInstance -ClassName Win32_UserProfile | Where-Object { $_.SID -eq $userSID }).LocalPath
if (-not $userProfile) {
    Write-Host "Could not find profile path for $Username (SID: $userSID)." -ForegroundColor Red
    exit 1
}
$shellValue = if ($Restore) { 'explorer.exe' } else { "$userProfile\\Documents\\Scripts\\Kiosk\\Menu.exe" }

# Check if the user's hive is loaded
if (-not (Test-Path $regPath)) {
    # Try to load the user's hive
    $ntuserDat = Join-Path $userProfile 'NTUSER.DAT'
    if (-not (Test-Path $ntuserDat)) {
        Write-Host "NTUSER.DAT not found at $ntuserDat. User profile may not exist or is not loaded." -ForegroundColor Red
        exit 1
    }
    try {
        reg load HKU\$userSID "$ntuserDat" | Out-Null
        $hiveLoaded = $true
        Write-Host "Loaded registry hive for $Username." -ForegroundColor Yellow
    }
    catch {
        Write-Host "Failed to load registry hive for $Username." -ForegroundColor Red
        exit 1
    }
}
else {
    $hiveLoaded = $false
}



# Ensure each parent key exists for the Winlogon key
$parentPath = "Registry::HKEY_USERS\$userSID\Software\Microsoft\Windows NT\CurrentVersion"
Write-Host "[DEBUG] Checking parent path: $parentPath" -ForegroundColor Cyan
if (-not (Test-Path $parentPath)) {
    Write-Host "[DEBUG] Creating parent key: Registry::HKEY_USERS\$userSID\Software\Microsoft\Windows NT Name='CurrentVersion'" -ForegroundColor Cyan
    try {
        New-Item -Path "Registry::HKEY_USERS\$userSID\Software\Microsoft\Windows NT" -Name 'CurrentVersion' -Force | Out-Null
        Write-Host '[DEBUG] Created parent key successfully.' -ForegroundColor Green
    }
    catch {
        Write-Host "[DEBUG] Failed to create parent key: $_" -ForegroundColor Red
    }
}
Write-Host "[DEBUG] Checking regPath: $regPath" -ForegroundColor Cyan
if (-not (Test-Path $regPath)) {
    Write-Host "[DEBUG] Creating Winlogon key: $regPath" -ForegroundColor Cyan
    try {
        New-Item -Path $parentPath -Name 'Winlogon' -Force | Out-Null
        Write-Host '[DEBUG] Created Winlogon key successfully.' -ForegroundColor Green
    }
    catch {
        Write-Host "[DEBUG] Failed to create Winlogon key: $_" -ForegroundColor Red
    }
}
Write-Host "[DEBUG] Verifying Winlogon key exists: $regPath" -ForegroundColor Cyan
if (-not (Test-Path $regPath)) {
    Write-Host "Failed to create Winlogon registry key for $Username." -ForegroundColor Red
    if ($hiveLoaded) {
        reg unload HKU\$userSID | Out-Null
        Write-Host "Unloaded registry hive for $Username." -ForegroundColor Yellow
    }
    exit 1
}

Write-Host '[DEBUG] Attempting to set Shell property using reg.exe' -ForegroundColor Cyan
$regKey = "HKU\$userSID\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"
$regCmd = "reg add `"$regKey`" /v Shell /t REG_SZ /d `"$shellValue`" /f"
Write-Host "[DEBUG] Running: $regCmd" -ForegroundColor Cyan
$regResult = cmd.exe /c $regCmd
Write-Host $regResult
if ($LASTEXITCODE -eq 0) {
    Write-Host '[DEBUG] Shell property set successfully using reg.exe.' -ForegroundColor Green
    if ($Restore) {
        Write-Host "Default shell restored to explorer.exe for $Username." -ForegroundColor Green
    }
    else {
        Write-Host "Custom shell set to $shellValue for $Username. Restart the computer to apply changes." -ForegroundColor Green
    }
}
else {
    Write-Host "Failed to set shell for $Username using reg.exe." -ForegroundColor Red
}
