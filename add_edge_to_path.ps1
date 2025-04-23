# PowerShell script to add Microsoft Edge to the system PATH
# Run this script as Administrator

$EdgePath = 'C:\Program Files (x86)\Microsoft\Edge\Application'

# Get the current system PATH
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)

# Check if Edge path is already in PATH
if ($oldPath -notlike "*${EdgePath}*") {
    $newPath = $oldPath + ';' + $EdgePath
    [Environment]::SetEnvironmentVariable('Path', $newPath, [EnvironmentVariableTarget]::Machine)
    Write-Host 'Edge path added to system PATH. Please restart your computer for changes to take effect.'
}
else {
    Write-Host 'Edge path is already in the system PATH.'
}
