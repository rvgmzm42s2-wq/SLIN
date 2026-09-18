function Read-SLINJson {
 param([Parameter(Mandatory)][string]$Path,[object]$Default=$null)
 if(-not(Test-Path $Path)){return $Default}
 try{$raw=Get-Content $Path -Raw -ErrorAction Stop;if([string]::IsNullOrWhiteSpace($raw)){return $Default};$raw|ConvertFrom-Json -ErrorAction Stop}
 catch{Write-SLINLog "JSON read failed: $Path :: $($_.Exception.Message)" "ERROR";$Default}
}
function Write-SLINJson {
 param([Parameter(Mandatory)][string]$Path,[Parameter(Mandatory)]$Object)
 $dir=Split-Path -Parent $Path;if($dir -and -not(Test-Path $dir)){New-Item -ItemType Directory -Path $dir -Force|Out-Null}
 $tmp="$Path.tmp";$Object|ConvertTo-Json -Depth 20|Set-Content $tmp -Encoding UTF8;Move-Item $tmp $Path -Force
}
