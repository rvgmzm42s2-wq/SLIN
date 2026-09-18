function Invoke-SLINDecisionLoop {
  param([object]$Context)
  $reason=Invoke-SLINReasoning $Context
  [pscustomobject]@{decision='observe';actions=@();confidence=$reason.confidence;reasoning=$reason;timestamp=(Get-Date).ToString('o')}
}