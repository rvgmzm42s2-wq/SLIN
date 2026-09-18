function Update-SLINLearning {
  param([object]$Observation,[object]$Outcome)
  $entry=[ordered]@{timestamp=(Get-Date).ToUniversalTime().ToString('o');observation=$Observation;outcome=$Outcome}
  $p=Join-Path $script:SLINRoot 'data/learning.jsonl'
  $entry|ConvertTo-Json -Depth 20|Add-Content $p
  [pscustomobject]$entry
}
function Get-SLINLearnedPatterns {
  $p=Join-Path $script:SLINRoot 'data/learning.jsonl'
  if(!(Test-Path $p)){return @()}
  @((Get-Content $p|%{try{$_|ConvertFrom-Json}catch{}})|Group-Object observation|Sort-Object Count -Descending|%{[pscustomobject]@{pattern=$_.Name;count=$_.Count}})
}