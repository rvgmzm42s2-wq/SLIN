function Get-SLINMemory {$items=@(Read-SLINJson (Get-SLINPath "data\memory.json") @());$items|Sort-Object created_utc -Descending}
function Add-SLINMemory {
 param([Parameter(Mandatory)][string]$Text,[string]$Kind="note")
 $p=Get-SLINPath "data\memory.json";$items=@(Read-SLINJson $p @())
 $item=[pscustomobject]@{id=[guid]::NewGuid().ToString();created_utc=(Get-Date).ToUniversalTime().ToString("o");kind=$Kind;text=$Text}
 Write-SLINJson $p (@($item)+$items|Select-Object -First 500);Write-SLINLog "Memory added: $($item.id)";$item
}
