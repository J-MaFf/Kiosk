# This script sets your custom shell (Menu.exe) as the default Windows shell for all users.
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
$shellValue = if ($Restore) { 'explorer.exe' } else { 'C:\\Users\\$Username\\Documents\\Scripts\\Kiosk\\Menu.exe' }

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
