# SLIN Architecture

Runtime -> Core -> Memory / State / Tone / Diagnostics / Sensors -> Self-test -> Reports.

Principles:
- local-first
- explicit local data files
- graceful hardware detection
- no permanent PowerShell execution-policy changes
- user data excluded from Git by default
- future local AI adapters can consume memory/state/diagnostic layers
