function Write-SLINAudit([string]$Action,[string]$Result){Write-SLINEvent 'audit' @{action=$Action;result=$Result}}
