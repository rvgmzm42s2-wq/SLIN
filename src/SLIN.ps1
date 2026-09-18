[CmdletBinding()]
param([Parameter(Position=0)][string]$Command='help',[Parameter(Position=1,ValueFromRemainingArguments=$true)][string[]]$Args)
$Root=Split-Path -Parent $PSScriptRoot
Get-ChildItem (Join-Path $Root 'core') -Filter '*.ps1'|Sort-Object Name|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'cognition') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'emotion') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'language') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'memory') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'perception') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'performance') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'tools') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'learning') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'security') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Get-ChildItem (Join-Path $Root 'interface') -Filter '*.ps1'|ForEach-Object{. $_.FullName}
Initialize-SLIN
function Show-SLINDashboard {
  Write-Host ''
  Write-Host '================ SLIN ================'
  Write-Host 'Local-first personal system'
  Write-Host '======================================'
  Get-SLINSelfState|Format-List
  Write-Host 'Tone:';Get-SLINConversationState|Format-List
}
switch($Command.ToLowerInvariant()){
 'status'{Show-SLINDashboard}
 'diagnose' {Invoke-SLINDiagnostics|Format-List}
 'diag' {Invoke-SLINDiagnostics|Format-List}
 'cpu'{Get-SLINCPUPerformance|Format-List}
 'gpu'{Get-SLINGPUPerformance|Format-List}
 'memory'{Get-SLINMemoryPerformance|Format-List}
 'storage'{Get-SLINStoragePerformance|Format-Table -AutoSize}
 'thermal'{Get-SLINThermalPerformance|Format-List}
 'fans'{Get-SLINFanPerformance|Format-List}
 'battery'{Get-SLINBatteryPerformance|Format-List}
 'sensors'{Get-SLINThermalPerformance;Get-SLINFanPerformance;Get-SLINBatteryPerformance}
 'tone'{
   if($Args.Count -lt 1){Write-Error 'Usage: tone <text>';break}
   $t=Get-SLINTone ($Args -join ' ');Update-SLINConversationState $t.tone
   $t;Get-SLINAffect $t.tone;Get-SLINResponseCalibration $t.tone
 }
 'remember'{if($Args.Count){Add-SLINLongTerm ($Args -join ' ')}else{Write-Error 'Usage: remember <text>'}}
 'recall'{if($Args.Count){Search-SLINMemory ($Args -join ' ')}else{Get-SLINLongTerm}}
 'beliefs'{Get-SLINBeliefs}
 'contradictions'{Find-SLINContradictions (Get-SLINBeliefs)}
 'health'{Invoke-SLINDiagnostics}
 'snapshot'{New-SLINRecoverySnapshot}
 'permissions'{Get-SLINPermissions}
 'selfstate'{Get-SLINSelfState}
 'patterns'{Find-SLINPatterns @((Get-Content (Get-SLINPath 'data/observations.jsonl') -ErrorAction SilentlyContinue))}
 'help'{Write-Host 'SLIN commands: status diagnose cpu gpu memory storage thermal fans battery sensors tone remember recall beliefs contradictions health snapshot permissions selfstate patterns help exit'}
 'shell'{Start-SLINTerminal}
 'version'{Write-Host 'SLIN 0.2.0 architecture build'}
 default{Write-Error "Unknown command '$Command'. Run: SLIN help"}
}
