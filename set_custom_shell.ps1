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


# Ensure Winlogon key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

try {
    Set-ItemProperty -Path $regPath -Name 'Shell' -Value $shellValue -Force
    if ($Restore) {
        Write-Host "Default shell restored to explorer.exe for $Username." -ForegroundColor Green
    }
    else {
        Write-Host "Custom shell set to $shellValue for $Username. Restart the computer to apply changes." -ForegroundColor Green
    }
}
catch {
    Write-Host "Failed to set shell for $Username. Try running as Administrator." -ForegroundColor Red
}

# Unload the hive if we loaded it
if ($hiveLoaded) {
    try {
        reg unload HKU\$userSID | Out-Null
        Write-Host "Unloaded registry hive for $Username." -ForegroundColor Yellow
    }
    catch {
        Write-Host "Failed to unload registry hive for $Username. You may need to unload it manually." -ForegroundColor Red
    }
}