function New-SLINContext([hashtable]$Input) {
  [pscustomobject]@{timestamp=(Get-Date).ToUniversalTime().ToString('o');facts=@($Input.Facts);goals=@($Input.Goals);observations=@($Input.Observations);session=$Input.Session}
}
