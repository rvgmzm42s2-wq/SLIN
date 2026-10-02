function Get-SLINIntent {
    param([Parameter(Mandatory)][string]$Text)
    $l=$Text.Trim().ToLowerInvariant()
    if($l -match "^remember\s+"){"memory_add"}
    elseif($l -match "^recall\s+"){"memory_recall"}
    elseif($l -match "^state\s+set\s+"){"state_set"}
    elseif($l -match "^state\s+belief\s+"){"belief_add"}
    elseif($l -match "\b(who are you|what are you)\b"){"identity"}
    elseif($l -match "\b(what can you do|help|commands)\b"){"capabilities"}
    elseif($l -match "\b(status|diagnose|health|selftest|sensors)\b"){"system"}
    elseif($l -match "\b(time|what time|date|what day)\b"){"time"}
    elseif($l -match "\b(angry|mad|pissed|frustrated|upset|sad|happy|excited|worried)\b"){"emotion"}
    else{"conversation"}
}

function Get-SLINToneFromText {
    param([Parameter(Mandatory)][string]$Text)
    $l=$Text.ToLowerInvariant()
    if($l -match "pissed|angry|mad|frustrated|damn|wtf"){return "frustrated"}
    if($l -match "excited|awesome|hell yes|let's go|great"){return "excited"}
    if($l -match "worried|scared|afraid|concerned"){return "uncertain"}
    if($l -match "urgent|emergency|asap|immediately"){return "urgent"}
    if($l -match "lol|haha|joke|funny"){return "joking"}
    if($l -match "love|miss you|thank you"){return "affectionate"}
    return "neutral"
}

function Invoke-SLINReasoning {
    param([Parameter(Mandatory)][string]$Text)
    $intent=Get-SLINIntent $Text
    $tone=Get-SLINToneFromText $Text
    [pscustomobject]@{
        intent=$intent
        tone=$tone
        normalized=$Text.Trim()
        has_memory=$intent -in @("memory_add","memory_recall")
        has_state=$intent -in @("state_set","belief_add")
        requires_system=$intent -eq "system"
        timestamp=(Get-Date).ToUniversalTime().ToString("o")
    }
}
