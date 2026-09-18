function Invoke-SLINDecisionLoop {
  param([object]$Context)
  $reason=Invoke-SLINReasoning $Context
  $action='respond'
  if(@($Context.contradictions).Count -gt 0){$action='surface-contradiction'}
  [pscustomobject]@{decision=$action;actions=@($action);confidence=$reason.confidence;reasoning=$reason;timestamp=(Get-Date).ToString('o')}
}