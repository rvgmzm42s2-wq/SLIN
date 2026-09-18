function Invoke-SLINConversation {
  param([Parameter(Mandatory)][string]$Text)

  $tone=Get-SLINTone $Text
  Update-SLINConversationState $tone.tone
  Add-SLINShortTerm @{role='user';text=$Text;tone=$tone.tone}
  Add-SLINObservation @{type='conversation';text=$Text;tone=$tone.tone}

  $mem=@(Search-SLINMemory $Text)
  $beliefs=@(Get-SLINBeliefs)
  $context=[pscustomobject]@{
    userText=$Text
    tone=$tone.tone
    memory=$mem
    beliefs=$beliefs
    contradictions=@(Find-SLINContradictions $beliefs)
    facts=$mem
    goals=@()
    observations=@($mem)
  }

  $decision=Invoke-SLINDecisionLoop $context
  Update-SLINSelfState $tone.tone $decision.decision | Out-Null

  if($decision.decision -eq 'store-or-confirm-memory'){
    $memoryText=$Text -replace '(?i)^\s*(remember|save|store)\s*[:,-]?\s*',''
    if($memoryText -and $memoryText -ne $Text){
      Add-SLINLongTerm $memoryText
    }
  }

  $response=Invoke-SLINNativeResponse -Text $Text -Context $context -Decision $decision
  Update-SLINLearning -Observation @{text=$Text;tone=$tone.tone;intent=$decision.intent} -Outcome @{action=$decision.decision} | Out-Null
  $style=Get-SLINResponseCalibration $tone.tone

  [pscustomobject]@{
    text=(ConvertTo-SLINResponseStyle $response $tone.tone)
    tone=$tone.tone
    calibration=$style
    decision=$decision
    context=$context
  }
}
