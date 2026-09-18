function Invoke-SLINReasoning {
  param([object]$Context)
  $facts=@($Context.facts);$goals=@($Context.goals);$observations=@($Context.observations)
  [pscustomobject]@{type='reasoning_result';facts=$facts;goals=$goals;observations=$observations;next_actions=@();confidence=0.5;method='bounded-local-rule-evaluation'}
}