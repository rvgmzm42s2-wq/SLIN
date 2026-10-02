[CmdletBinding()]
param([string]$Destination=(Join-Path $env:USERPROFILE 'SLIN'))
$Source=Split-Path -Parent $MyInvocation.MyCommand.Path
New-Item -ItemType Directory -Path $Destination -Force|Out-Null
Get-ChildItem $Source -Force|?{$_.Name -notin @('.git','.github')}|%{Copy-Item $_.FullName (Join-Path $Destination $_.Name) -Recurse -Force}

$desktop=[Environment]::GetFolderPath('Desktop')
if($desktop -and (Test-Path $desktop)){
    $shortcutPath=Join-Path $desktop 'Silin.lnk'
    $shell=New-Object -ComObject WScript.Shell
    $shortcut=$shell.CreateShortcut($shortcutPath)
    $shortcut.TargetPath=(Join-Path $Destination 'SLIN.vbs')
    $shortcut.WorkingDirectory=$Destination
    $shortcut.Description='Silin - local personal AI system'
    $shortcut.IconLocation=(Join-Path $env:WINDIR 'System32\shell32.dll') + ',44'
    $shortcut.Save()
}
Write-Host "SLIN installed to $Destination"
Write-Host "Silin desktop shortcut created."
