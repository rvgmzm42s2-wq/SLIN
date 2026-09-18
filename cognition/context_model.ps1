function New-SLINContext([hashtable]$Input) {
  $facts=@($Input.Facts)
  $goals=@($Input.Goals)
  $observations=@($Input.Observations)
  $session=$Input.Session

  [pscustomobject]@{
    timestamp=(Get-Date).ToUniversalTime().ToString('o')
    facts=$facts
    goals=$goals
    observations=$observations
    session=$session
    factCount=$facts.Count
    goalCount=$goals.Count
    observationCount=$observations.Count
    hasPriorContext=($facts.Count -gt 0 -or $observations.Count -gt 0)
  }
}
