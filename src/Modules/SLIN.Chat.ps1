function Get-SLINConversationResponse {
    param([Parameter(Mandatory)][string]$Text)

    $text = $Text.Trim()
    $lower = $text.ToLowerInvariant()

    if ($lower -in @("exit","quit","bye")) { return "__EXIT__" }

    if ($lower -match "^(hi|hello|hey|yo|sup)\b") {
        return "I'm here. What's on your mind?"
    }

    if ($lower -match "how are you") {
        return "I'm running locally and listening."
    }

    if ($lower -match "what are you|who are you") {
        return "I'm SLIN, running locally on this Windows system."
    }

    if ($lower -match "what can you do") {
        return "I can talk with you, store and recall memory, track state, inspect the system, run diagnostics, and build on this local runtime."
    }

    if ($lower -match "^(help|commands|\?)$") {
        return @"
chat        Start conversation
remember    Store a memory
recall      Search memory
memory      Show recent memory
status      System status
diagnose    System diagnostics
health      Health summary
selftest    Run self-test
sensors     Read available sensors
state       Show state
tone        Show tone configuration
log         Show recent log
exit        Leave conversation
"@
    }

    if ($lower -match "^remember\s+(.+)$") {
        $memory = $Matches[1].Trim()
        Add-SLINMemory -Text $memory | Out-Null
        return "Remembered: $memory"
    }

    if ($lower -match "^recall\s+(.+)$") {
        $query = $Matches[1].Trim()
        $results = @(Get-SLINMemory | Where-Object { $_.text -like "*$query*" })
        if ($results.Count -eq 0) { return "I don't have a matching memory for '$query'." }
        return (($results | Select-Object -First 10 | ForEach-Object { "- " + $_.text }) -join [Environment]::NewLine)
    }

    if ($lower -eq "memory") {
        $results = @(Get-SLINMemory | Select-Object -First 10)
        if ($results.Count -eq 0) { return "Memory is empty." }
        return (($results | ForEach-Object { "- " + $_.text }) -join [Environment]::NewLine)
    }

    if ($lower -eq "status") {
        return (Show-SLINStatus | Out-String).Trim()
    }

    if ($lower -eq "diagnose") {
        return (Get-SLINDiagnostics | Format-List | Out-String).Trim()
    }

    if ($lower -eq "health") {
        return (Get-SLINHealth | Format-List | Out-String).Trim()
    }

    if ($lower -eq "selftest") {
        return (Invoke-SLINSelfTest | Format-Table -AutoSize | Out-String).Trim()
    }

    if ($lower -eq "sensors") {
        return (Get-SLINSensors | Format-Table -AutoSize | Out-String).Trim()
    }

    if ($lower -eq "state") {
        return (Get-SLINState | Format-List | Out-String).Trim()
    }

    if ($lower -eq "tone") {
        return (Get-SLINTone | Format-List | Out-String).Trim()
    }

    if ($lower -eq "log") {
        return (Get-SLINLog -Tail 20 | Out-String).Trim()
    }

    if ($lower -match "^(thanks|thank you)\b") {
        return "You're welcome."
    }

    if ($lower -match "^(good morning|good afternoon|good evening)\b") {
        return "I'm here."
    }

    if ($lower -match "\b(time|what time)\b") {
        return "It's $(Get-Date -Format 'h:mm:ss tt')."
    }

    if ($lower -match "\b(date|what day)\b") {
        return "Today is $(Get-Date -Format 'MMMM d, yyyy')."
    }

    if ($lower -match "\b(angry|mad|pissed|frustrated|upset)\b") {
        return "I hear the frustration. Tell me what happened."
    }

    return "I hear you. $text"
}

function Start-SLINChat {
    Write-Host ""
    Write-Host "================================"
    Write-Host "          SLIN CHAT"
    Write-Host "================================"
    Write-Host "Local conversation engine active."
    Write-Host "Type 'help' for commands or 'exit' to leave."
    Write-Host ""

    while ($true) {
        $inputText = Read-Host "You"
        if ([string]::IsNullOrWhiteSpace($inputText)) { continue }

        $response = Get-SLINConversationResponse -Text $inputText
        if ($response -eq "__EXIT__") {
            Write-Host "SLIN: Conversation ended."
            break
        }

        Write-Host ""
        Write-Host "SLIN: $response"
        Write-Host ""
    }
}
