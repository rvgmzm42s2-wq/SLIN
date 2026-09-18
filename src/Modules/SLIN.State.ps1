function Get-SLINState {
 $p=Get-SLINPath "data\state.json";$s=Read-SLINJson $p $null
 if($null -eq $s){$s=[pscustomobject]@{version="0.1.0";updated_utc=$null;context=[pscustomobject]@{};beliefs=@()};Write-SLINJson $p $s};$s
}
function Set-SLINStateValue {
 param([Parameter(Mandatory)][string]$Key,[Parameter(Mandatory)][string]$Value)
 $s=Get-SLINState;$s.context|Add-Member NoteProperty $Key $Value -Force;$s.updated_utc=(Get-Date).ToUniversalTime().ToString("o")
 Write-SLINJson (Get-SLINPath "data\state.json") $s;Write-SLINLog "State set: $Key";$Value
}
function Add-SLINBelief {
 param([Parameter(Mandatory)][string]$Key,[Parameter(Mandatory)][string]$Value,[double]$Confidence=0.5,[string]$Source="user")
 $s=Get-SLINState;$b=[pscustomobject]@{id=[guid]::NewGuid().ToString();key=$Key;value=$Value;confidence=[math]::Max(0,[math]::Min(1,$Confidence));source=$Source;created_utc=(Get-Date).ToUniversalTime().ToString("o")}
 $s.beliefs=@($b)+@($s.beliefs)|Select-Object -First 500;$s.updated_utc=(Get-Date).ToUniversalTime().ToString("o");Write-SLINJson (Get-SLINPath "data\state.json") $s;$b
}
