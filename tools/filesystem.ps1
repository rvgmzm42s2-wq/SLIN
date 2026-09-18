function Get-SLINFileInfo([string]$Path){Get-Item -LiteralPath $Path -EA Stop|select FullName,Length,LastWriteTime,Attributes}
