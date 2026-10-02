function Add-SLINObservation {
    param([Parameter(Mandatory)][string]$Observation,[string]$Outcome="observed")
    $p=Get-SLINPath "data\observations.json"
    $items=@(Read-SLINJson $p @())
    $item=[pscustomobject]@{
        id=[guid]::NewGuid().ToString()
        utc=(Get-Date).ToUniversalTime().ToString("o")
        observation=$Observation
        outcome=$Outcome
    }
    Write-SLINJson $p (@($item)+$items|Select-Object -First 1000)
    Write-SLINLog "Observation recorded: $($item.id)"
    $item
}

function Get-SLINObservations {
    @(Read-SLINJson (Get-SLINPath "data\observations.json") @())|Sort-Object utc -Descending
}
