function New-SLINHealthReport {
 $stamp=(Get-Date).ToString("yyyyMMdd-HHmmss");$path=Get-SLINPath "reports\SLIN-health-$stamp.txt"
 $h=Get-SLINHealth;$t=Invoke-SLINSelfTest;$s=Get-SLINSensors
 $text="SLIN HEALTH REPORT"+[Environment]::NewLine+"Generated UTC: "+(Get-Date).ToUniversalTime().ToString("o")+[Environment]::NewLine+[Environment]::NewLine+"HEALTH"+[Environment]::NewLine+($h|Out-String)+"SELF TEST"+[Environment]::NewLine+($t|Format-Table -AutoSize|Out-String)+"SENSORS"+[Environment]::NewLine+($s|Format-Table -AutoSize|Out-String)
 Set-Content -LiteralPath $path -Value $text -Encoding UTF8;Write-SLINLog "Health report created: $path";$path
}
