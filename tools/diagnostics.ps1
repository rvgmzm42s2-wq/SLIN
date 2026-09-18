function Invoke-SLINDiagnostics {
  [pscustomobject]@{
    system=Get-SLINSystemPerception
    hardware=Get-SLINHardwarePerception
    cpu=Get-SLINCPUPerformance
    gpu=Get-SLINGPUPerformance
    memory=Get-SLINMemoryPerformance
    storage=Get-SLINStoragePerformance
    thermal=Get-SLINThermalPerformance
    fans=Get-SLINFanPerformance
    hardwareMonitor=Get-SLINHardwareMonitor
    battery=Get-SLINBatteryPerformance
  }
}
