function Invoke-SLINDecisionLoop([hashtable]$Context) {
  $r=Invoke-SLINReasoning $Context
  [pscustomobject]@{timestamp=(Get-Date).ToUniversalTime().ToString('o'); reasoning=$r; decision='observe'; actions=@(); confidence=1.0}
}
