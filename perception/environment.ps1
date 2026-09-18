function Get-SLINEnvironmentPerception{[pscustomobject]@{user=$env:USERNAME;computer=$env:COMPUTERNAME;time=(Get-Date).ToString('o');powershell=$PSVersionTable.PSVersion.ToString()}}
