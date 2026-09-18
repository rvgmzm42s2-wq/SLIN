function Invoke-SLINAutomation([scriptblock]$Action,[switch]$WhatIf){if($WhatIf){return 'DRY-RUN'};&$Action}
