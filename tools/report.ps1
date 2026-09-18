function Export-SLINReport {
  param([string]$Path=(Get-SLINPath ('reports/slin-'+(Get-Date -Format 'yyyyMMdd-HHmmss')+'.json')))
  $report=[ordered]@{timestamp=(Get-Date).ToString('o');selfState=Get-SLINSelfState;diagnostics=Invoke-SLINDiagnostics}
  $json=$report|ConvertTo-Json -Depth 8
  $parent=Split-Path -Parent $Path; New-Item -ItemType Directory -Path $parent -Force|Out-Null
  Set-Content -Path $Path -Value $json -Encoding UTF8
  Get-Item $Path
}