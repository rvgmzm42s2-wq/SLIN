function Get-SLINSensors {
 $r=New-Object System.Collections.Generic.List[object]
 try{$z=Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction Stop;foreach($x in @($z)){$r.Add([pscustomobject]@{Provider="WMI";Sensor="ThermalZone";Value=[math]::Round(($x.CurrentTemperature/10)-273.15,1);Unit="C";Status="available"})}}
 catch{$r.Add([pscustomobject]@{Provider="WMI";Sensor="ThermalZone";Value=$null;Unit="C";Status="unavailable"})}
 $r.Add([pscustomobject]@{Provider="Windows";Sensor="FanSpeed";Value=$null;Unit="RPM";Status="not_exposed_by_standard_WMI"});@($r)
}
