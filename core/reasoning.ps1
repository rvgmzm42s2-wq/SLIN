function Invoke-SLINReasoning([hashtable]$Context) {
  $facts=@($Context.Facts); $goals=@($Context.Goals); $observations=@($Context.Observations)
  [pscustomobject]@{ type='reasoning_result'; facts=$facts; goals=$goals; observations=$observations; next_actions=@(); method='bounded-local-rule-evaluation' }
}
