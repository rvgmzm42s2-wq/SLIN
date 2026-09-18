function New-SLINSession {
  param([string]$Id=([guid]::NewGuid().ToString()))
  [pscustomobject]@{id=$Id;started=(Get-Date).ToString('o');turn=0;lastTone='neutral'}
}