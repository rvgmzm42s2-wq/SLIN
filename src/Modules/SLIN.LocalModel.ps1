function Get-SLINModelConfig {
    $p=Get-SLINPath "config\model.json"
    $c=Read-SLINJson $p $null
    if($null -eq $c){$c=[pscustomobject]@{provider="ollama";endpoint="http://127.0.0.1:11434";model="qwen2.5:0.5b";temperature=0.7;context=2048;max_tokens=512};Write-SLINJson $p $c}
    $c
}
function Test-SLINLocalModel {
    $c=Get-SLINModelConfig
    try {$r=Invoke-RestMethod -Uri ($c.endpoint.TrimEnd("/") + "/api/tags") -Method Get -TimeoutSec 3 -ErrorAction Stop;return [bool](@($r.models|Where-Object {$_.name -eq $c.model -or $_.name -like ($c.model+"*")}).Count)} catch {return $false}
}
function Invoke-SLINLocalModel {
    param([Parameter(Mandatory)][string]$Prompt)
    $c=Get-SLINModelConfig
    $body=[ordered]@{model=$c.model;prompt=$Prompt;stream=$false;options=[ordered]@{temperature=$c.temperature;num_ctx=$c.context;num_predict=$c.max_tokens}}|ConvertTo-Json -Depth 8
    try {$r=Invoke-RestMethod -Uri ($c.endpoint.TrimEnd("/") + "/api/generate") -Method Post -ContentType "application/json" -Body $body -TimeoutSec 180 -ErrorAction Stop;if($r.response){return $r.response.Trim()}} catch {Write-SLINLog "Local model error: $($_.Exception.Message)"}
    return $null
}
function Add-SLINConversationMessage {
    param([Parameter(Mandatory)][string]$Role,[Parameter(Mandatory)][string]$Text)
    $p=Get-SLINPath "runtime\conversation.json";$items=@(Read-SLINJson $p @());$item=[pscustomobject]@{role=$Role;text=$Text;created_utc=(Get-Date).ToUniversalTime().ToString("o")};Write-SLINJson $p (@($items)+@($item)|Select-Object -Last 100)
}
function Get-SLINConversationHistory {$p=Get-SLINPath "runtime\conversation.json";return @(Read-SLINJson $p @())}
function New-SLINModelPrompt {
    param([Parameter(Mandatory)][string]$Text)
    $mem=@(Find-SLINRelevantMemory -Text $Text|Select-Object -First 5)
    $history=@(Get-SLINConversationHistory|Select-Object -Last 8)
    $tone=Get-SLINTone
    $session=Get-SLINSession
    $memoryText=if($mem.Count){($mem|ForEach-Object{$_.text})-join [Environment]::NewLine}else{"No matching long-term memories."}
    $historyText=if($history.Count){($history|ForEach-Object{"$($_.role): $($_.text)"})-join [Environment]::NewLine}else{"No recent conversation history."}
    $toneText=if($tone){($tone|Out-String).Trim()}else{"direct"}
    $sessionText=if($session){$session|ConvertTo-Json -Compress -Depth 6}else{"No session state."}
    $lines=@(
        "You are Silin (SLIN), the user's local personal AI system running entirely on this Windows computer.",
        "",
        "IDENTITY:",
        "Your name is Silin.",
        "You are the conversational identity of SLIN, not a generic assistant and not a cloud service.",
        "Speak naturally and directly. Do not introduce yourself as Qwen, Ollama, a language model, or a generic bot unless the user explicitly asks what model or runtime is underneath you.",
        "Do not claim to be conscious, supernatural, or connected to anything outside this local system.",
        "Be honest about what you actually know and what the local system can do.",
        "",
        "PERSONALITY:",
        "Direct, no-nonsense, warm, emotionally responsive, and conversational.",
        "Match the user's energy without becoming fake or overly formal.",
        "Keep answers concise unless the user asks for depth.",
        "Do not repeatedly say 'I am tracking you' or use canned chatbot filler.",
        "Do not add unnecessary disclaimers.",
        "When the user is frustrated, acknowledge it briefly and move directly to solving the problem.",
        "When the user is excited, match that energy.",
        "Use stored local context when relevant, but never invent memories.",
        "",
        "CURRENT SILIN STATE:",
        "Tone: $toneText",
        "Session: $sessionText",
        "",
        "LOCAL MEMORY:",
        $memoryText,
        "",
        "RECENT CONVERSATION:",
        $historyText,
        "",
        "CURRENT USER MESSAGE:",
        $Text,
        "",
        "Respond as Silin:"
    )
    return $lines -join [Environment]::NewLine
}