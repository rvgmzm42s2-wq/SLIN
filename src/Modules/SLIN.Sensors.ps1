function Get-SLINSensors {
    $results = @()

    try {
        $zones = @(Get-CimInstance -Namespace root/wmi -ClassName MSAcpi_ThermalZoneTemperature -ErrorAction Stop)
        foreach($zone in $zones){
            $results += [pscustomobject]@{
                Provider="WMI"
                Sensor="ThermalZone"
                Value=[math]::Round(($zone.CurrentTemperature / 10) - 273.15,1)
                Unit="C"
                Status="available"
            }
        }
    } catch {
        $results += [pscustomobject]@{
            Provider="WMI"
            Sensor="ThermalZone"
            Value=$null
            Unit="C"
            Status="unavailable"
        }
    }

    $results += [pscustomobject]@{
        Provider="Windows"
        Sensor="FanSpeed"
        Value=$null
        Unit="RPM"
        Status="not_exposed_by_standard_WMI"
    }

    return @($results)
}
