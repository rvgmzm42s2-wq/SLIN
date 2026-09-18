[CmdletBinding()]
param([string]$Destination=(Join-Path $env:USERPROFILE 'SLIN'))
$Source=Split-Path -Parent $MyInvocation.MyCommand.Path
New-Item -ItemType Directory -Path $Destination -Force|Out-Null
Get-ChildItem $Source -Force|?{$_.Name -notin @('.git','.github')}|%{Copy-Item $_.FullName (Join-Path $Destination $_.Name) -Recurse -Force}
Write-Host "SLIN installed to $Destination"
