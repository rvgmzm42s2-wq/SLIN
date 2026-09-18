function Start-SLINApp {
  if(Get-Command Start-SLINDesktop -EA SilentlyContinue){Start-SLINDesktop;return}
  Clear-Host;Write-Host 'SLIN - native local system';Write-Host 'Type /help or /exit.'
  while($true){
    $text=Read-Host 'YOU';if(!$text){continue};if($text -eq '/exit'){break}
    switch -Regex($text){
      '^/help$'{Write-Host '/status /diagnose /remember <text> /recall <text> /selftest /benchmark /report /provider /exit';continue}
      '^/status$'{Get-SLINSelfState|Format-List;continue}
      '^/diagnose$'{Invoke-SLINDiagnostics|Format-List;continue}
      '^/provider$'{Get-SLINProviderStatus|Format-List;continue}
      '^/selftest$'{Invoke-SLINSelfTest|Format-List;continue}
      '^/benchmark$'{Invoke-SLINBenchmark|Format-List;continue}
      '^/report$'{Export-SLINReport|Format-List;continue}
      '^/remember ' {Add-SLINLongTerm ($text.Substring(10));Write-Host 'SLIN: remembered.';continue}
      '^/recall ' {Search-SLINMemory ($text.Substring(8));continue}
      default{$x=Invoke-SLINConversation $text;Write-Host ('SLIN ['+$x.tone+']: '+$x.text)}
    }
  }
}