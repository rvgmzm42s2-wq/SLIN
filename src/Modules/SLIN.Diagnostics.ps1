function Get-SLINDiagnostics {
 $os=Get-CimInstance Win32_OperatingSystem -ErrorAction SilentlyContinue;$cs=Get-CimInstance Win32_ComputerSystem -ErrorAction SilentlyContinue;$cpu=Get-CimInstance Win32_Processor -ErrorAction SilentlyContinue|Select-Object -First 1
 $ds=@(Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" -ErrorAction SilentlyContinue);$gpu=@(Get-CimInstance Win32_VideoController -ErrorAction SilentlyContinue)
 $mem=if($cs -and $cs.TotalPhysicalMemory){100*(1-($os.FreePhysicalMemory*1KB/$cs.TotalPhysicalMemory))}else{$null}
 $di=foreach($d in $ds){if($d.Size){[pscustomobject]@{Drive=$d.DeviceID;FreeGB=[math]::Round($d.FreeSpace/1GB,1);UsedPercent=[math]::Round((1-$d.FreeSpace/$d.Size)*100,1)}}}
 [pscustomobject]@{Computer=$env:COMPUTERNAME;OS=$os.Caption;OSVersion=$os.Version;Uptime=(Get-Date)-$os.LastBootUpTime;CPU=$cpu.Name;CPU_LoadPercent=if($cpu){$cpu.LoadPercentage}else{$null};RAM_TotalGB=if($cs){[math]::Round($cs.TotalPhysicalMemory/1GB,1)}else{$null};RAM_UsedPercent=if($mem -ne $null){[math]::Round($mem,1)}else{$null};Processes=(Get-Process).Count;Services=(Get-Service).Count;GPUs=($gpu|% Name)-join "; ";Disks=$di}
}
function Get-SLINHealth {
 $d=Get-SLINDiagnostics;$c=Read-SLINJson (Get-SLINPath "config\slin.json") @{};$mw=if($c.diagnostics.memory_warning_percent){$c.diagnostics.memory_warning_percent}else{85};$dw=if($c.diagnostics.disk_warning_percent){$c.diagnostics.disk_warning_percent}else{90};$issues=@()
 if($d.RAM_UsedPercent -ge $mw){$issues+="High memory use"};foreach($x in @($d.Disks)){if($x.UsedPercent -ge $dw){$issues+="Low disk space on $($x.Drive)"}}
 [pscustomobject]@{Status=if($issues.Count){"WARN"}else{"OK"};Issues=if($issues.Count){$issues-join "; "}else{"No threshold warnings"};Diagnostics=$d}
}
