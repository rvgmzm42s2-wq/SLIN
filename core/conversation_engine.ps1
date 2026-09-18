function Invoke-SLINConversation {
  param([Parameter(Mandatory)][string]$Text)
  $tone=Get-SLINTone $Text
  Update-SLINConversationState $tone.tone
  Add-SLINShortTerm @{role='user';text=$Text;tone=$tone.tone;timestamp=(Get-Date).ToString('o')}
  $context=[pscustomobject]@{userText=$Text;tone=$tone.tone;memory=(Search-SLINMemory $Text);beliefs=(Get-SLINBeliefs);contradictions=(Find-SLINContradictions (Get-SLINBeliefs))}
  $decision=Invoke-SLINDecisionLoop $context
  [pscustomobject]@{text=('I received your message. Tone detected: '+$tone.tone+'. The conversation engine is active.');tone=$tone.tone;calibration=(Get-SLINResponseCalibration $tone.tone);decision=$decision;context=$context}
}