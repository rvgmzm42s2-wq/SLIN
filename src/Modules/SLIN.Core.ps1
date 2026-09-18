$script:SLINRoot=$null
function Get-SLINPath {param([Parameter(Mandatory)][string]$RelativePath);Join-Path $script:SLINRoot ($RelativePath -replace "/","\")}
function Initialize-SLIN {
 param([Parameter(Mandatory)][string]$Root);$script:SLINRoot=$Root
 foreach($d in @("config","data","logs","reports","runtime")){$p=Get-SLINPath $d;if(-not(Test-Path $p)){New-Item -ItemType Directory -Path $p -Force|Out-Null}}
 $log=Get-SLINPath "logs\slin.log";if(-not(Test-Path $log)){New-Item -ItemType File -Path $log -Force|Out-Null}
 if(-not(Test-Path (Get-SLINPath "config\slin.json"))){[pscustomobject]@{version="0.1.0";name="SLIN";tone=[pscustomobject]@{profile="direct";concise=$true;adaptive=$true}}|ConvertTo-Json -Depth 10|Set-Content (Get-SLINPath "config\slin.json") -Encoding UTF8}
 Write-SLINLog "Runtime initialized at $Root"
}
function Show-SLINStatus {
 $c=Read-SLINJson (Get-SLINPath "config\slin.json") @{}
 [pscustomobject]@{Name="SLIN";Version=$c.version;Root=$script:SLINRoot;Host=$env:COMPUTERNAME;OS=[Environment]::OSVersion.VersionString;PowerShell=$PSVersionTable.PSVersion.ToString();UTC=(Get-Date).ToUniversalTime().ToString("o")}|Format-List
}
function Show-SLINHelp {
@"
SLIN commands:
 status | health | diagnose | sensors | selftest | report
 memory | remember <text> | state | tone | log | version | help
 state set <key> <value>
 state belief <key> <value> [confidence] [source]
"@
}
