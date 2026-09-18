[CmdletBinding()]
param([Parameter(Position=0)][string]$Command='help',[Parameter(Position=1,ValueFromRemainingArguments=$true)][string[]]$Args)
$Root=Split-Path -Parent $PSScriptRoot
foreach($dir in @('core','cognition','emotion','language','memory','perception','performance','tools','learning','security','interface')){
 Get-ChildItem (Join-Path $Root $dir) -Filter '*.ps1' -EA SilentlyContinue|Sort-Object Name|%{. $_.FullName}
}
Initialize-SLIN
switch($Command.ToLowerInvariant()){
'status'{Get-SLINSelfState|Format-List}
'diagnose'{Invoke-SLINDiagnostics|Format-List}
'cpu'{Get-SLINCPUPerformance|Format-List}
'gpu'{Get-SLINGPUPerformance|Format-List}
'memory'{Get-SLINMemoryPerformance|Format-List}
'storage'{Get-SLINStoragePerformance|Format-Table -AutoSize}
'thermal'{Get-SLINThermalPerformance|Format-List}
'fans'{Get-SLINFanPerformance|Format-List}
'battery'{Get-SLINBatteryPerformance|Format-List}
'sensors'{Get-SLINThermalPerformance;Get-SLINFanPerformance;Get-SLINBatteryPerformance}
'tone'{if(!$Args.Count){Write-Error 'Usage: tone <text>';break};$t=Get-SLINTone ($Args-join ' ');Update-SLINConversationState $t.tone;$t;Get-SLINAffect $t.tone;Get-SLINResponseCalibration $t.tone}
'remember'{if($Args.Count){Add-SLINLongTerm ($Args-join ' ')}else{Write-Error 'Usage: remember <text>'}}
'recall'{if($Args.Count){Search-SLINMemory ($Args-join ' ')}else{Get-SLINLongTerm}}
'beliefs'{Get-SLINBeliefs}
'contradictions'{Find-SLINContradictions (Get-SLINBeliefs)}
'health'{Invoke-SLINDiagnostics}
'snapshot'{New-SLINRecoverySnapshot}
'permissions'{Get-SLINPermissions}
'selfstate'{Get-SLINSelfState}
'help'{Write-Host 'SLIN: status diagnose cpu gpu memory storage thermal fans battery sensors tone remember recall beliefs contradictions health snapshot permissions selfstate help shell version'}
'shell'{Start-SLINTerminal}
'version'{Write-Host 'SLIN 0.2.0'}
default{Write-Error "Unknown command '$Command'. Run: SLIN help"}
}
