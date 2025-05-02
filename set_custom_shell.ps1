param(
    [switch]$Restore
)

# Set the shell value
$shellValue = if ($Restore) { 'explorer.exe' } else { "$env:USERPROFILE\\Documents\\Scripts\\Kiosk\\Menu.exe" }
$regPath = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon'

# Ensure the Winlogon key exists
if (-not (Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set the Shell property
Set-ItemProperty -Path $regPath -Name 'Shell' -Value $shellValue -Force

if ($Restore) {
    Write-Host "Default shell restored to explorer.exe for $env:USERNAME." -ForegroundColor Green
}
else {
    Write-Host "Custom shell set to $shellValue for $env:USERNAME. Restart the computer to apply changes." -ForegroundColor Green
}