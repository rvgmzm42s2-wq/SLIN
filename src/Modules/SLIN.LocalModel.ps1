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
    $mem=@(Find-SLINRelevantMemory -Text $Text|Select-Object -First 5);$history=@(Get-SLINConversationHistory|Select-Object -Last 8)
    $memoryText=if($mem.Count){($mem|ForEach-Object{$_.text})-join [Environment]::NewLine}else{"No matching long-term memories."}
    $historyText=if($history.Count){($history|ForEach-Object{"$($_.role): $($_.text)"})-join [Environment]::NewLine}else{"No recent conversation history."}
    return "You are SLIN, a local Windows personal AI system. Be direct, honest, useful, and conversational. Do not invent facts. Use stored memory and recent conversation when relevant."+[Environment]::NewLine+[Environment]::NewLine+"LOCAL MEMORY:"+[Environment]::NewLine+$memoryText+[Environment]::NewLine+[Environment]::NewLine+"RECENT CONVERSATION:"+[Environment]::NewLine+$historyText+[Environment]::NewLine+[Environment]::NewLine+"CURRENT USER:"+[Environment]::NewLine+$Text+[Environment]::NewLine+[Environment]::NewLine+"SLIN RESPONSE:"
}