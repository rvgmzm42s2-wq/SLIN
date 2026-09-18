Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$script:SLINRoot=Split-Path -Parent $PSScriptRoot
function Get-SLINRoot { $script:SLINRoot }
function Get-SLINPath([string]$RelativePath) { Join-Path $script:SLINRoot $RelativePath }
function Initialize-SLIN {
  foreach($d in @('data','logs','reports','runtime')) {
    $p=Get-SLINPath $d
    if(!(Test-Path $p)){New-Item -ItemType Directory -Path $p -Force|Out-Null}
  }
  $state=Get-SLINPath 'data/state.json'
  if(!(Test-Path $state)){@{version=1;values=@{};beliefs=@()}|ConvertTo-Json -Depth 10|Set-Content -Encoding UTF8 $state}
}
function Write-SLINEvent([string]$Type,[object]$Data){
  [ordered]@{timestamp=(Get-Date).ToUniversalTime().ToString('o');type=$Type;data=$Data}|ConvertTo-Json -Depth 12|Add-Content -Encoding UTF8 (Get-SLINPath 'logs/slin.jsonl')
}
