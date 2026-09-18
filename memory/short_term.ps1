$script:SLINShortTerm = [System.Collections.Generic.List[object]]::new()
function Add-SLINShortTerm($Item){$script:SLINShortTerm.Add([pscustomobject]@{timestamp=(Get-Date).ToUniversalTime().ToString('o');item=$Item})}
function Get-SLINShortTerm { @($script:SLINShortTerm) }
