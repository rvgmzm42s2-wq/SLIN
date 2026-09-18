function Update-SLINLearning {
  param([object]$Observation,[object]$Outcome)

  $text=[string]$Observation.text
  $tone=[string]$Observation.tone
  $action=[string]$Outcome.action
  $normalized=($text.ToLowerInvariant() -replace '[^a-z0-9\s]',' ' -replace '\s+',' ').Trim()
  $key=$tone+'|'+$action+'|'+$normalized

  $entry=[ordered]@{
    timestamp=(Get-Date).ToUniversalTime().ToString('o')
    observation=$Observation
    outcome=$Outcome
    patternKey=$key
  }
  $p=Join-Path $script:SLINRoot 'data/learning.jsonl'
  $entry|ConvertTo-Json -Depth 20|Add-Content $p
  [pscustomobject]$entry
}

function Get-SLINLearnedPatterns {
  $p=Join-Path $script:SLINRoot 'data/learning.jsonl'
  if(!(Test-Path $p)){return @()}

  $rows=@()
  foreach($line in Get-Content $p){
    try{$rows+=$line|ConvertFrom-Json}catch{}
  }

  @($rows|Group-Object patternKey|Sort-Object Count -Descending|ForEach-Object{
    $sample=$_.Group|Select-Object -Last 1
    [pscustomobject]@{
      pattern=$_.Name
      count=$_.Count
      lastSeen=$sample.timestamp
      tone=$sample.observation.tone
      action=$sample.outcome.action
    }
  })
}
