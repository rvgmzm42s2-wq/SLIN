function Get-SLINBeliefs {
  $p=Join-Path $script:SLINRoot 'data/state.json'; if(!(Test-Path $p)){return @()}
  $s=Get-Content $p -Raw|ConvertFrom-Json; return @($s.beliefs)
}
function Add-SLINBelief([string]$Key,[object]$Value,[double]$Confidence=0.5,[string]$Source='local') {
  $p=Join-Path $script:SLINRoot 'data/state.json'; $s=Get-Content $p -Raw|ConvertFrom-Json
  $b=[pscustomobject]@{key=$Key;value=$Value;confidence=[math]::Max(0,[math]::Min(1,$Confidence));source=$Source;timestamp=(Get-Date).ToUniversalTime().ToString('o')}
  $s.beliefs=@($s.beliefs)+$b; $s|ConvertTo-Json -Depth 20|Set-Content $p; $b
}
