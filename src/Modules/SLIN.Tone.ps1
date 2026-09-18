function Get-SLINTone {$c=Read-SLINJson (Get-SLINPath "config\slin.json") @{};if($c.tone){$c.tone}else{[pscustomobject]@{profile="direct";concise=$true;adaptive=$true}}}
