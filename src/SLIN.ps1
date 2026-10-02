[CmdletBinding()]
param(
    [Parameter(Position=0)][string]$Command='help',
    [Parameter(Position=1,ValueFromRemainingArguments=$true)][string[]]$Args
)

$Root=Split-Path -Parent $PSScriptRoot

$Modules=@(
    "SLIN.Core.ps1",
    "SLIN.Json.ps1",
    "SLIN.Logging.ps1",
    "SLIN.State.ps1",
    "SLIN.Memory.ps1",
    "SLIN.Tone.ps1",
    "SLIN.Sensors.ps1",
    "SLIN.Diagnostics.ps1",
    "SLIN.SelfTest.ps1",
    "SLIN.Report.ps1",
    "SLIN.Chat.ps1"
)

foreach($module in $Modules){
    $file=Join-Path $PSScriptRoot "Modules\$module"
    if(Test-Path $file){ . $file }
}

Initialize-SLIN -Root $Root

switch($Command.ToLowerInvariant()){
    "chat"      { Start-SLINChat }
    "status"    { Show-SLINStatus }
    "diagnose"  { Get-SLINDiagnostics | Format-List }
    "health"    { Get-SLINHealth | Format-List }
    "sensors"   { Get-SLINSensors | Format-Table -AutoSize }
    "selftest"  { Invoke-SLINSelfTest | Format-Table -AutoSize }
    "memory"    { Get-SLINMemory | Format-Table -AutoSize }
    "remember"  { if($Args.Count){ Add-SLINMemory -Text ($Args -join " ") }else{ Write-Error "Usage: remember <text>" } }
    "state"     { Get-SLINState | Format-List }
    "tone"      { Get-SLINTone | Format-List }
    "log"       { Get-SLINLog | Out-Host }
    "report"    { New-SLINHealthReport }
    "help"      { Show-SLINHelp }
    "version"   { Write-Host "SLIN 0.5.0" }
    default     { Write-Error "Unknown command '$Command'. Run: SLIN help" }
}
