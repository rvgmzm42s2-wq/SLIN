function Invoke-SLINNativeResponse {
  param([Parameter(Mandatory)][string]$Text,[object]$Context,[object]$Decision)

  $tone=[string]$Context.tone
  $reason=$Decision.reasoning
  $intent=[string]$reason.intent
  $mem=@($Context.memory).Count
  $contr=@($Context.contradictions).Count

  switch($intent){
    'greeting' {$response='Hello. SLIN is here and running natively.'}
    'question' {
      $response='I can work through that using the information available to SLIN.'
      if($mem -gt 0){$response+=' I found '+$mem+' related memory record(s).'}
    }
    'memory' {$response='I can store that in SLIN local memory.'}
    'diagnostic' {$response='I can inspect the available system, hardware, performance, and diagnostic data.'}
    'status' {$response='SLIN is running in native mode with local memory, cognition, learning, and diagnostics.'}
    'help' {$response='SLIN can converse, recognize tone, use local memory, reason over structured context, learn from observations and outcomes, and run system diagnostics.'}
    'problem' {$response='I will break the problem into observable facts, available memory, system state, and next actions.'}
    default {$response='I received that and processed it through the native SLIN cognition pipeline.'}
  }

  if($contr -gt 0){$response+=' I also found '+$contr+' contradiction(s) in the available belief state.'}
  if($tone -eq 'frustrated'){$response+=' I will keep it direct and focus on the actual problem.'}
  elseif($tone -eq 'urgent'){$response+=' I will prioritize the immediate issue.'}
  elseif($tone -eq 'excited'){$response+=' I am tracking the momentum.'}

  $response
}
