function Invoke-SLINTerminal([string]$Command,[switch]$WhatIf){if($WhatIf){return [pscustomobject]@{command=$Command;executed=$false}};& powershell.exe -NoLogo -NoProfile -Command $Command}
