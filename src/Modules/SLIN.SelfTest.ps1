function Invoke-SLINSelfTest {
 $t=New-Object System.Collections.Generic.List[object];function T($n,$p,$d){$t.Add([pscustomobject]@{Test=$n;Pass=[bool]$p;Detail=$d})}
 foreach($p in @("config","data","logs","reports","runtime")){T "Path:$p" (Test-Path (Get-SLINPath $p)) (Get-SLINPath $p)}
 try{$p=Get-SLINPath "data\selftest.json";Write-SLINJson $p ([pscustomobject]@{ok=$true});$x=Read-SLINJson $p $null;T "JSON read/write" ($x.ok -eq $true) "round trip";Remove-Item $p -Force -ErrorAction SilentlyContinue}catch{T "JSON read/write" $false $_.Exception.Message}
 try{$o=Get-CimInstance Win32_OperatingSystem -ErrorAction Stop;T "CIM OS" $true $o.Caption}catch{T "CIM OS" $false $_.Exception.Message}
 try{$d=Get-SLINDiagnostics;T "Diagnostics" ($null-ne $d) "query completed"}catch{T "Diagnostics" $false $_.Exception.Message}
 T "Sensor discovery" ((@(Get-SLINSensors)).Count -gt 0) "safe probe";@($t)
}
