function Invoke-SLINReasoning {
  param([object]$Context)

  $facts=@($Context.facts)
  $goals=@($Context.goals)
  $observations=@($Context.observations)
  $text=[string]$Context.userText
  $intent='general'
  if($text -match '^\s*(hi|hello|hey)\b'){$intent='greeting'}
  elseif($text -match '\?$'){$intent='question'}
  elseif($text -match '(?i)\b(remember|save|store)\b'){$intent='memory'}
  elseif($text -match '(?i)\b(diagnose|diagnostic|health|cpu|gpu|memory|storage|thermal|fan|battery)\b'){$intent='diagnostic'}
  elseif($text -match '(?i)\b(status|state|how are you)\b'){$intent='status'}
  elseif($text -match '(?i)\b(help|what can you do)\b'){$intent='help'}
  elseif($text -match '(?i)\b(error|broken|not working|problem|issue|fix)\b'){$intent='problem'}

  $next=@()
  switch($intent){
    'greeting' {$next+='greet'}
    'question' {$next+='answer-question'}
    'memory' {$next+='store-or-confirm-memory'}
    'diagnostic' {$next+='inspect-system-state'}
    'status' {$next+='report-self-state'}
    'help' {$next+='explain-capabilities'}
    'problem' {$next+='analyze-problem'}
    default {$next+='analyze-request'}
  }

  $confidence=0.55
  if($facts.Count -gt 0){$confidence+=0.1}
  if($observations.Count -gt 0){$confidence+=0.1}
  if(@($Context.contradictions).Count -gt 0){$confidence-=0.15}
  if($confidence -gt 0.95){$confidence=0.95}
  if($confidence -lt 0.1){$confidence=0.1}

  [pscustomobject]@{
    type='reasoning_result'
    intent=$intent
    facts=$facts
    goals=$goals
    observations=$observations
    next_actions=$next
    confidence=$confidence
    method='native-local-intent-and-rule-evaluation'
  }
}
