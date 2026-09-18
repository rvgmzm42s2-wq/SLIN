Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$script:SLINRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
function Get-SLINRoot { $script:SLINRoot }
function Get-SLINPath([string]$RelativePath) { Join-Path $script:SLINRoot $RelativePath }
function Initialize-SLIN {
  foreach($d in @('data','logs','reports','runtime')) { $p=Get-SLINPath $d; if(!(Test-Path $p)){New-Item -ItemType Directory -Path $p -Force|Out-Null} }
  if(!(Test-Path (Get-SLINPath 'data/state.json'))){ @{ version=1; values=@{}; beliefs=@() } | ConvertTo-Json -Depth 10 | Set-Content (Get-SLINPath 'data/state.json') }
}
function Write-SLINEvent([string]$Type,[object]$Data) {
  $e=[ordered]@{timestamp=(Get-Date).ToUniversalTime().ToString('o');type=$Type;data=$Data}
  $e|ConvertTo-Json -Depth 12|Add-Content (Get-SLINPath 'logs/slin.jsonl')
}
