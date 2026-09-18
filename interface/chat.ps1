function Start-SLINChat {
  Write-Host "SLIN interactive session. Type /help, /status, /diagnose, /remember <text>, /recall <text>, or /exit."
  $session=New-SLINSession
  while($true){
    $inputText=Read-Host "YOU"
    if(!$inputText){continue}
    if($inputText -eq "/exit"){break}
    if($inputText -eq "/help"){Write-Host "/status /diagnose /remember /recall /tone /exit";continue}
    if($inputText -eq "/status"){Get-SLINSelfState|Format-List;continue}
    if($inputText -eq "/diagnose"){Invoke-SLINDiagnostics|Format-List;continue}
    if($inputText -like "/remember *"){Add-SLINLongTerm ($inputText.Substring(10));Write-Host "SLIN: remembered.";continue}
    if($inputText -like "/recall *"){Search-SLINMemory ($inputText.Substring(8));continue}
    $tone=Get-SLINTone $inputText
    $session.turn++;$session.lastTone=$tone.tone
    Update-SLINConversationState $tone.tone
    $cal=Get-SLINResponseCalibration $tone.tone
    Write-Host ("SLIN ["+$cal.mode+"]: "+(ConvertTo-SLINResponseStyle ("Received: "+$inputText) $tone.tone))
  }
}