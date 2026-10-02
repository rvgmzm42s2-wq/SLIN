function Get-SLINSession {
    $p=Get-SLINPath "runtime\session.json"
    $s=Read-SLINJson $p $null
    if($null -eq $s){
        $s=[pscustomobject]@{
            started_utc=(Get-Date).ToUniversalTime().ToString("o")
            turns=0
            last_intent=$null
            last_tone="neutral"
            topics=@()
        }
        Write-SLINJson $p $s
    }
    $s
}

function Update-SLINSession {
    param([string]$Intent,[string]$Tone,[string]$Text)
    $s=Get-SLINSession
    $s.turns=[int]$s.turns+1
    $s.last_intent=$Intent
    $s.last_tone=$Tone
    if($Text){
        $words=$Text.ToLowerInvariant() -split "\W+" | Where-Object {$_.Length -ge 5} | Select-Object -First 5
        $s.topics=@($words)+@($s.topics)|Select-Object -Unique -First 25
    }
    Write-SLINJson (Get-SLINPath "runtime\session.json") $s
    $s
}
