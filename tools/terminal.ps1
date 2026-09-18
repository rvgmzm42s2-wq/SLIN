function Invoke-SLINTerminal {
  param([Parameter(Mandatory)][string]$Command,[switch]$WhatIf,[switch]$Force)
  if($WhatIf){return [pscustomobject]@{command=$Command;executed=$false;mode='dry-run'}}
  $blocked='Remove-Item|Clear-Disk|Format-Volume|diskpart|Set-ExecutionPolicy|shutdown|Restart-Computer|Stop-Computer|reg.exe\s+delete'
  if(!$Force -and $Command -match $blocked){return [pscustomobject]@{command=$Command;executed=$false;blocked=$true;reason='Destructive command blocked by SLIN safe execution policy.'}}
  [pscustomobject]@{command=$Command;executed=$true;output=(& powershell.exe -NoLogo -NoProfile -Command $Command 2>&1 | Out-String)}
}