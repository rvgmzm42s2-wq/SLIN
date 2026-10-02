function Get-SLINContextSnapshot {
    $session=Get-SLINSession
    $state=Get-SLINState
    $mem=@(Get-SLINMemory|Select-Object -First 12)
    [pscustomobject]@{
        session=$session
        state=$state
        memories=$mem
    }
}

function Find-SLINRelevantMemory {
    param([Parameter(Mandatory)][string]$Text)
    $terms=@($Text.ToLowerInvariant()-split '\W+'|Where-Object{$_.Length -ge 4}|Select-Object -Unique)
    if(!$terms.Count){return @()}
    $items=@(Get-SLINMemory)
    $scored=foreach($m in $items){
        $score=0
        foreach($t in $terms){if($m.text.ToLowerInvariant().Contains($t)){$score++}}
        if($score -gt 0){[pscustomobject]@{score=$score;memory=$m}}
    }
    @($scored|Sort-Object score -Descending|Select-Object -First 5|ForEach-Object{$_.memory})
}

function Get-SLINConversationalAnswer {
    param(
        [Parameter(Mandatory)][string]$Text,
        [Parameter(Mandatory)]$Reason
    )
    $ctx=Get-SLINContextSnapshot
    $relevant=@(Find-SLINRelevantMemory $Text)
    $l=$Text.ToLowerInvariant().Trim()

    if($l -match '^(hi|hey|hello|yo|sup)\b'){
        return 'Hey. I''m here. What are we working on?'
    }
    if($l -match '\b(thank|thanks)\b'){
        return 'You got it.'
    }
    if($l -match '\b(who am i|what do you know about me)\b'){
        if($relevant.Count){return 'From what I have stored locally: '+(($relevant|ForEach-Object{$_.text})-join '; ')}
        return 'I don''t have enough matching information in my local memory yet.'
    }
    if($l -match '\b(what did i say|do you remember|remember when)\b'){
        if($relevant.Count){return 'Yeah. I have this locally: '+(($relevant|ForEach-Object{$_.text})-join '; ')}
        return 'I don''t have a matching memory for that yet.'
    }
    if($l -match '\b(what are we doing|where were we|continue)\b'){
        $topic=@($ctx.session.topics)
        if($topic.Count){return 'We were working around: '+($topic|Select-Object -First 8)-join ', '+'.'}
        return 'This session doesn''t have a strong topic trail yet.'
    }
    if($l -match '\b(are you there|you there|awake)\b'){return 'Yeah. I''m running locally and listening.'}
    if($l -match '\b(what can you do)\b'){return 'I can keep local memory, track session context, maintain beliefs and state, detect intent and tone, learn from observations, inspect Windows, and reason over information stored in the local runtime.'}
    if($Reason.tone -eq 'frustrated'){return 'I can tell you''re frustrated. Give me the exact problem and I''ll work it through with you instead of just repeating it.'}
    if($Reason.tone -eq 'excited'){return 'I''m with you. Let''s push it forward.'}
    if($Reason.tone -eq 'uncertain'){return 'I hear the uncertainty. We can break it down and work from what we actually know.'}
    if($Reason.tone -eq 'urgent'){return 'Got it. I''ll keep this focused and work the problem step by step.'}
    if($Reason.tone -eq 'affectionate'){return 'I''m here with you.'}
    if($Reason.tone -eq 'joking'){return 'I caught the joke. Keep going.'}

    if($relevant.Count){
        $m=($relevant|Select-Object -First 1).text
        return 'I understand the point. The closest thing I have in local context is: '+$m+'. Tell me what you want to do with it.'
    }

    $words=@($l-split '\W+'|Where-Object{$_.Length -ge 5}|Select-Object -Unique|Select-Object -First 6)
    if($words.Count){
        $focus=$words -join ', '
        return 'I''m tracking this around '+$focus+'. Give me the goal or question and I''ll work from that context.'
    }
    return 'I''m tracking you. Give me the goal and I''ll work it through.'
}
