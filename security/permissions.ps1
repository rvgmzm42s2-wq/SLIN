function Get-SLINPermissions {
  $id=[Security.Principal.WindowsIdentity]::GetCurrent()
  $p=[Security.Principal.WindowsPrincipal]$id
  [pscustomobject]@{user=$env:USERNAME;isAdministrator=$p.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);executionPolicy=(Get-ExecutionPolicy -List|Out-String).Trim();scope='process-safe-launchers'}
}