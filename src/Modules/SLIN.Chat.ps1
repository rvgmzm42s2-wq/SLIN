function Get-SLINConversationResponse {
    param([Parameter(Mandatory)][string]$Text)

    $text=$Text.Trim()
    if($text.ToLowerInvariant() -in @("exit","quit","bye")){return "__EXIT__"}

    $reason=Invoke-SLINReasoning -Text $text
    Update-SLINSession -Intent $reason.intent -Tone $reason.tone -Text $text | Out-Null

    switch($reason.intent){
        "memory_add" {
            if($text -match "^remember\s+(.+)$"){
                $m=$Matches[1].Trim()
                Add-SLINMemory -Text $m -Kind "conversation" | Out-Null
                Add-SLINObservation -Observation "User requested memory: $m" -Outcome "stored" | Out-Null
                return "Remembered: $m"
            }
        }
        "memory_recall" {
            if($text -match "^recall\s+(.+)$"){
                $q=$Matches[1].Trim()
                $r=@(Get-SLINMemory|Where-Object{$_.text -like "*$q*"}|Select-Object -First 10)
                if(!$r.Count){return "I don't have a matching memory for '$q'."}
                return (($r|ForEach-Object{"- "+$_.text})-join [Environment]::NewLine)
            }
        }
        "state_set" {
            if($text -match "^state\s+set\s+(\S+)\s+(.+)$"){
                Set-SLINStateValue -Key $Matches[1] -Value $Matches[2].Trim()|Out-Null
                return "State updated: $($Matches[1]) = $($Matches[2].Trim())"
            }
        }
        "belief_add" {
            if($text -match "^state\s+belief\s+(\S+)\s+(.+)$"){
                Add-SLINBelief -Key $Matches[1] -Value $Matches[2].Trim() -Source "conversation"|Out-Null
                return "Belief stored: $($Matches[1]) = $($Matches[2].Trim())"
            }
        }
        "identity" {return "I'm SLIN — a local Windows system with persistent memory, context, beliefs, reasoning, tone, learning, diagnostics, and self-tests."}
        "capabilities" {return "I can remember and recall information, track context, maintain beliefs and state, recognize intent and tone, learn observations, inspect Windows, and reason over local context."}
        "system" {
            if($text.ToLowerInvariant() -eq "status"){return (Show-SLINStatus|Out-String).Trim()}
            if($text.ToLowerInvariant() -eq "health"){return (Get-SLINHealth|Format-List|Out-String).Trim()}
            if($text.ToLowerInvariant() -eq "selftest"){return (Invoke-SLINSelfTest|Format-Table -AutoSize|Out-String).Trim()}
            if($text.ToLowerInvariant() -eq "sensors"){return (Get-SLINSensors|Format-Table -AutoSize|Out-String).Trim()}
            return (Get-SLINDiagnostics|Format-List|Out-String).Trim()
        }
        "time" {
            if($text.ToLowerInvariant() -match "date|day"){return "Today is $(Get-Date -Format 'MMMM d, yyyy')."}
            return "It's $(Get-Date -Format 'h:mm:ss tt')."
        }
        "emotion" {return Get-SLINConversationalAnswer -Text $text -Reason $reason
        }
    }

    if($text.ToLowerInvariant() -in @("help","commands","?")){
        return "Commands: remember, recall, memory, state, state set, state belief, status, diagnose, health, selftest, sensors, tone, observations, log, exit"
    }
    if($text.ToLowerInvariant() -eq "memory"){
        $r=@(Get-SLINMemory|Select-Object -First 10)
        if(!$r.Count){return "Memory is empty."}
        return (($r|ForEach-Object{"- "+$_.text})-join [Environment]::NewLine)
    }
    if($text.ToLowerInvariant() -eq "state"){return (Get-SLINState|ConvertTo-Json -Depth 10).Trim()}
    if($text.ToLowerInvariant() -eq "tone"){return (Get-SLINTone|Format-List|Out-String).Trim()}
    if($text.ToLowerInvariant() -eq "log"){return (Get-SLINLog -Tail 20|Out-String).Trim()}
    if($text.ToLowerInvariant() -eq "observations"){return (Get-SLINObservations|Select-Object -First 20|Format-Table -AutoSize|Out-String).Trim()}

    return Get-SLINConversationalAnswer -Text $text -Reason $reason
}

function Start-SLINChat {
    Write-Host ""
    Write-Host "================================"
    Write-Host "          SLIN CHAT"
    Write-Host "================================"
    Write-Host "Local cognitive conversation engine active."
    Write-Host "Memory, context, reasoning, tone, learning, and diagnostics are available."
    Write-Host "Type 'help' for commands or 'exit' to leave."
    Write-Host ""

    while($true){
        $inputText=Read-Host "You"
        if([string]::IsNullOrWhiteSpace($inputText)){continue}
        $response=Get-SLINConversationResponse -Text $inputText
        if($response -eq "__EXIT__"){Write-Host "SLIN: Conversation ended.";break}
        Write-Host ""
        Write-Host "SLIN: $response"
        Write-Host ""
    }
}
