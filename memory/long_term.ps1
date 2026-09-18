function Add-SLINLongTerm($Item,[string[]]$Tags=@()) {
  $p=Join-Path $script:SLINRoot 'data/long-term.jsonl'; [ordered]@{timestamp=(Get-Date).ToUniversalTime().ToString('o');item=$Item;tags=$Tags}|ConvertTo-Json -Depth 10|Add-Content $p
}
function Get-SLINLongTerm { $p=Join-Path $script:SLINRoot 'data/long-term.jsonl'; if(Test-Path $p){Get-Content $p|ForEach-Object {$_|ConvertFrom-Json}} }
