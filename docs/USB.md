# SLIN USB Build

The active target is Windows.

Copy the entire **SLIN** repository folder to a USB drive. On a Windows PC, double-click **SLIN-APP.cmd** to launch the SLIN desktop interface.

The launcher uses a process-scoped PowerShell execution-policy bypass; it does not permanently change the Windows execution policy.

For command-line access, run **SLIN.cmd help**.

The USB copy is a portable application/project folder, not a bootable operating system.

Hardware sensor availability depends on Windows support and available providers. Fan RPM and detailed temperatures may be unavailable on some systems.