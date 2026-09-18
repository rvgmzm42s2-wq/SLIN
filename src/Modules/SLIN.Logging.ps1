function Write-SLINLog {
 param([Parameter(Mandatory)][string]$Message,[ValidateSet("INFO","WARN","ERROR","DEBUG")][string]$Level="INFO")
 if(-not $script:SLINRoot){return};$p=Join-Path $script:SLINRoot "logs\slin.log"
 Add-Content $p ("{0} [{1}] {2}" -f (Get-Date).ToUniversalTime().ToString("o"),$Level,$Message) -Encoding UTF8
}
function Get-SLINLog {param([int]$Tail=50);Get-Content (Get-SLINPath "logs\slin.log") -Tail $Tail -ErrorAction SilentlyContinue}
