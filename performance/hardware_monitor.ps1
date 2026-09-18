function Get-SLINHardwareMonitor {
  # Provider abstraction. Standard Windows providers are checked first.
  # A future LibreHardwareMonitor adapter can populate the same schema.
  $result=[ordered]@{available=$false;provider='none';cpuTemperatureC=$null;gpuTemperatureC=$null;fans=@();note='No supported hardware-monitor provider detected.'}
  $names=@('LibreHardwareMonitorLib','OpenHardwareMonitorLib')
  foreach($n in $names){
    $asm=[AppDomain]::CurrentDomain.GetAssemblies()|?{$_.GetName().Name -eq $n}|select -First 1
    if($asm){$result.available=$true;$result.provider=$n;break}
  }
  [pscustomobject]$result
}
