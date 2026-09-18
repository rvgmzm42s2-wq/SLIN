function Get-SLINGPUPerformance{@(Get-CimInstance Win32_VideoController|select Name,DriverVersion,AdapterRAM)}
