[CmdletBinding()]
param([Parameter(Position=0)][string]$Command='help',[Parameter(Position=1,ValueFromRemainingArguments=$true)][string[]]$Args)
$Root=Split-Path -Parent $PSScriptRoot
$loadOrder=@('core/runtime.ps1','core/reasoning.ps1','core/decision_loop.ps1','core/self_state.ps1','core/session.ps1','cognition/belief_map.ps1','cognition/belief_confidence.ps1','cognition/contradiction_detection.ps1','cognition/context_model.ps1','cognition/pattern_learning.ps1','emotion/tone_recognition.ps1','emotion/conversational_state.ps1','emotion/affect_model.ps1','emotion/response_calibration.ps1','language/style_engine.ps1','language/adaptive_language.ps1','language/vocabulary_profile.ps1','language/communication_modes.ps1','memory/short_term.ps1','memory/long_term.ps1','memory/episodic.ps1','memory/semantic.ps1','memory/memory_index.ps1','perception/system.ps1','perception/hardware.ps1','perception/network.ps1','perception/environment.ps1','performance/cpu.ps1','performance/gpu.ps1','performance/memory.ps1','performance/storage.ps1','performance/thermal.ps1','performance/fans.ps1','performance/battery.ps1','performance/hardware_monitor.ps1','tools/diagnostics.ps1','tools/self_test.ps1','tools/report.ps1','performance/benchmark.ps1','tools/terminal.ps1','tools/filesystem.ps1','tools/automation.ps1','learning/observations.ps1','learning/experiments.ps1','learning/outcomes.ps1','learning/procedures.ps1','security/permissions.ps1','security/audit.ps1','security/recovery.ps1','providers/local_provider.ps1','core/conversation_engine.ps1','interface/terminal.ps1','interface/chat.ps1','interface/app.ps1','interface/desktop.ps1');foreach($rel in $loadOrder){$file=Join-Path $Root $rel;if(Test-Path $file){. $file}}

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
'selftest'{Invoke-SLINSelfTest|Format-List}
'report'{Export-SLINReport|Format-List}
'benchmark'{Invoke-SLINBenchmark|Format-List}
'snapshot'{New-SLINRecoverySnapshot}
'permissions'{Get-SLINPermissions}
'selfstate'{Get-SLINSelfState}
'help'{Write-Host 'SLIN: status diagnose cpu gpu memory storage thermal fans battery sensors tone remember recall beliefs contradictions health snapshot permissions selfstate help shell chat version'}
'shell'{Start-SLINTerminal}
'chat'{Start-SLINChat}
'app'{Start-SLINApp}
'chat'{Start-SLINChat}
'version'{Write-Host 'SLIN 0.3.0'}
default{Write-Error "Unknown command '$Command'. Run: SLIN help"}
}
