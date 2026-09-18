[CmdletBinding()]
param([string]$InstallRoot=(Join-Path $env:USERPROFILE "SLIN"))
$sourceRoot=Split-Path -Parent $PSScriptRoot
if(-not(Test-Path (Join-Path $sourceRoot "src\SLIN.ps1"))){throw "Run install.ps1 from the SLIN repository."}
foreach($d in @("src","src\Modules","config","data","logs","reports","runtime")){New-Item -ItemType Directory -Path (Join-Path $InstallRoot $d) -Force|Out-Null}
Copy-Item (Join-Path $sourceRoot "src\*") (Join-Path $InstallRoot "src") -Recurse -Force
Copy-Item (Join-Path $sourceRoot "config\slin.json") (Join-Path $InstallRoot "config\slin.json") -Force
$cmd='@echo off'+[Environment]::NewLine+'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0src\SLIN.ps1" %*'
Set-Content (Join-Path $InstallRoot "SLIN.cmd") $cmd -Encoding ASCII
Set-Content (Join-Path $InstallRoot "START-HERE.txt") "SLIN installed. Run SLIN.cmd health." -Encoding UTF8
Write-Host "SLIN installed to $InstallRoot"
