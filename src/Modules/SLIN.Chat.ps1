function Get-SLINConversationResponse {
    param([Parameter(Mandatory)][string]$Text)
    $text=$Text.Trim();$lower=$text.ToLowerInvariant()
    if($lower -in @("exit","quit","bye")){return "__EXIT__"}
    $reason=Invoke-SLINReasoning -Text $text
    Update-SLINSession -Intent $reason.intent -Tone $reason.tone -Text $text|Out-Null
    Add-SLINConversationMessage -Role "user" -Text $text|Out-Null
    if($lower -match "^remember\s+(.+)$"){$m=$Matches[1].Trim();Add-SLINMemory -Text $m -Kind "conversation"|Out-Null;Add-SLINObservation -Observation "User requested memory: $m" -Outcome "stored"|Out-Null;$response="Remembered: $m";Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -match "^recall\s+(.+)$"){$q=$Matches[1].Trim();$r=@(Get-SLINMemory|Where-Object{$_.text -like "*$q*"}|Select-Object -First 10);if(!$r.Count){$response="No matching memory for $q."}else{$response=(($r|ForEach-Object{"- "+$_.text})-join [Environment]::NewLine)};Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "memory"){$r=@(Get-SLINMemory|Select-Object -First 10);if(!$r.Count){$response="Memory is empty."}else{$response=(($r|ForEach-Object{"- "+$_.text})-join [Environment]::NewLine)};Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "state"){$response=(Get-SLINState|ConvertTo-Json -Depth 10).Trim();Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "tone"){$response=(Get-SLINTone|Format-List|Out-String).Trim();Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "status"){$response=(Show-SLINStatus|Out-String).Trim();Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "health"){$response=(Get-SLINHealth|Format-List|Out-String).Trim();Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "diagnose"){$response=(Get-SLINDiagnostics|Format-List|Out-String).Trim();Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "selftest"){$response=(Invoke-SLINSelfTest|Format-Table -AutoSize|Out-String).Trim();Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -eq "sensors"){$response=(Get-SLINSensors|Format-Table -AutoSize|Out-String).Trim();Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -in @("help","commands","?")){$response="Commands: remember, recall, memory, state, status, diagnose, health, selftest, sensors, tone, exit. Normal messages go to the local language model.";Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if($lower -match "^state\s+set\s+(\S+)\s+(.+)$"){Set-SLINStateValue -Key $Matches[1] -Value $Matches[2].Trim()|Out-Null;$response="State updated: $($Matches[1]) = $($Matches[2].Trim())";Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    if(Test-SLINLocalModel){
        $response=Invoke-SLINLocalModel -Prompt (New-SLINModelPrompt -Text $text)
        if($response){Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null;return $response}
    }
    $response="Silin local AI is unavailable right now. I am not switching to the fallback bot."
    Add-SLINConversationMessage -Role "assistant" -Text $response|Out-Null
    return $response
}
function Start-SLINChat {
    Write-Host "";Write-Host "================================";Write-Host "          SILIN CHAT";Write-Host "================================";if(Test-SLINLocalModel){Write-Host "Local language model: ONLINE"}else{Write-Host "Local language model: OFFLINE - start the model setup"};Write-Host "Silin identity, memory, context, reasoning, tone, learning, and diagnostics are active.";Write-Host "Type help for commands or exit to leave.";Write-Host ""
    while($true){$inputText=Read-Host "You";if([string]::IsNullOrWhiteSpace($inputText)){continue};$response=Get-SLINConversationResponse -Text $inputText;if($response -eq "__EXIT__"){Write-Host "Silin: Conversation ended.";break};Write-Host "";Write-Host "Silin: $response";Write-Host ""}
}