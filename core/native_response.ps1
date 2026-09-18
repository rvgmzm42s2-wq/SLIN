function Invoke-SLINNativeResponse {
  param([Parameter(Mandatory)][string]$Text,[object]$Context,[object]$Decision)
  $tone=$Context.tone
  $mem=@($Context.memory).Count
  $contr=@($Context.contradictions).Count
  $parts=@()
  if($Text -match '^\s*(hi|hello|hey)\b'){$parts+=@('Hello.','I am here.')}
  elseif($Text -match '\?$'){
    $parts+=@('I can work through that with you.')
    if($mem -gt 0){$parts+=('I found '+$mem+' related memory record(s).')}
    if($contr -gt 0){$parts+=('I also found '+$contr+' belief contradiction(s) to surface.')}
  } else {$parts+=('I received that and processed it through the native SLIN pipeline.')}
  if($tone -eq 'frustrated'){$parts+=('I will keep it direct and focus on the actual problem.')}
  elseif($tone -eq 'urgent'){$parts+=('I will prioritize the immediate issue.')}
  elseif($tone -eq 'excited'){$parts+=('I am tracking the momentum.')}
  [string]::Join(' ',$parts)
}