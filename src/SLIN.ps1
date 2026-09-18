[CmdletBinding()]
param([Parameter(Position=0)][string]$Command="help",[Parameter(Position=1,ValueFromRemainingArguments=$true)][string[]]$Args)
$Root=Split-Path -Parent $PSScriptRoot
$modulePath=Join-Path $PSScriptRoot "Modules"
Get-ChildItem $modulePath -Filter "SLIN.*.ps1"|Sort-Object Name|ForEach-Object{. $_.FullName}
Initialize-SLIN -Root $Root
switch($Command.ToLowerInvariant()){
 "status"{Show-SLINStatus}
 "health"{Get-SLINHealth|Format-List}
 "diagnose"{Get-SLINDiagnostics|Format-List}
 "diag"{Get-SLINDiagnostics|Format-List}
 "sensors"{Get-SLINSensors|Format-Table -AutoSize}
 "selftest"{Invoke-SLINSelfTest|Format-Table -AutoSize}
 "report"{New-SLINHealthReport}
 "memory"{Get-SLINMemory|Format-Table -AutoSize}
 "remember"{if($Args.Count-lt 1){Write-Error "Usage: remember <text>";break};Add-SLINMemory ($Args-join " ")}
 "state"{
  if($Args.Count-eq 0){Get-SLINState|ConvertTo-Json -Depth 20;break}
  switch($Args[0].ToLowerInvariant()){
   "set"{if($Args.Count-lt 3){Write-Error "Usage: state set <key> <value>";break};Set-SLINStateValue $Args[1] (($Args[2..($Args.Count-1)])-join " ")}
   "belief"{if($Args.Count-lt 3){Write-Error "Usage: state belief <key> <value> [confidence] [source]";break};$c=if($Args.Count-ge 4){[double]$Args[3]}else{0.5};$s=if($Args.Count-ge 5){$Args[4]}else{"user"};Add-SLINBelief $Args[1] $Args[2] $c $s}
   default{Write-Error "Unknown state command."}
  }
 }
 "tone"{Get-SLINTone|Format-List}
 "log"{Get-SLINLog}
 "version"{"SLIN 0.1.0"}
 "help"{Show-SLINHelp}
 default{Write-Error "Unknown command '$Command'. Run: SLIN help"}
}
