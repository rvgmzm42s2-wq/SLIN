function Invoke-SLINDecisionLoop {
  param([object]$Context)

  $reason=Invoke-SLINReasoning $Context
  $action='respond'

  switch([string]$reason.intent){
    'memory'    {$action='store-or-confirm-memory'}
    'diagnostic'{$action='inspect-system-state'}
    'status'    {$action='report-self-state'}
    'help'      {$action='explain-capabilities'}
    'problem'   {$action='analyze-problem'}
    'question'  {$action='answer-question'}
    'greeting'  {$action='greet'}
  }

  if(@($Context.contradictions).Count -gt 0){$action='surface-contradiction'}

  [pscustomobject]@{
    decision=$action
    actions=@($reason.next_actions)
    confidence=$reason.confidence
    intent=$reason.intent
    reasoning=$reason
    timestamp=(Get-Date).ToUniversalTime().ToString('o')
  }
}
