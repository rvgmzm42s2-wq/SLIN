# SLIN

SLIN is a local-first personal system foundation for persistent memory, structured state, adaptive tone, diagnostics, hardware sensor discovery, logging, self-tests, and health reports.

## v0.1.0

Windows PowerShell 5.1 runtime. ExecutionPolicy Bypass is used only for the launched process; SLIN does not permanently change PowerShell execution policy.

### Run

From the repository:

    powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\src\SLIN.ps1 health

Or install to your user profile with install.ps1, which creates SLIN.cmd.

### Commands

- status
- health
- diagnose
- sensors
- selftest
- report
- memory
- remember <text>
- state
- state set <key> <value>
- state belief <key> <value> [confidence] [source]
- tone
- log
- version
- help

User memory and runtime data are excluded from Git by default.`n`n'performance/hardware_monitor.ps1' provides a safe provider abstraction for detailed thermal/fan telemetry without claiming unavailable sensor data.`n