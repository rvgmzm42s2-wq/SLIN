function Get-SLINSelfState {
  [pscustomobject]@{name='SLIN'; mode='local'; status='running'; timestamp=(Get-Date).ToUniversalTime().ToString('o')}
}
