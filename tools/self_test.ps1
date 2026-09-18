function Invoke-SLINSelfTest {
  $tests=@()
  $tests += [pscustomobject]@{name='root';passed=(Test-Path (Get-SLINRoot));detail=(Get-SLINRoot)}
  $tests += [pscustomobject]@{name='config';passed=(Test-Path (Get-SLINPath 'config/slin.json'));detail=(Get-SLINPath 'config/slin.json')}
  $tests += [pscustomobject]@{name='data';passed=(Test-Path (Get-SLINPath 'data'));detail=(Get-SLINPath 'data')}
  $tests += [pscustomobject]@{name='memory';passed=($null -ne (Get-SLINLongTerm));detail='Long-term memory accessible'}
  try { $d=Invoke-SLINDiagnostics; $tests += [pscustomobject]@{name='diagnostics';passed=($null -ne $d.system -and $null -ne $d.cpu);detail='Core diagnostics returned'} } catch { $tests += [pscustomobject]@{name='diagnostics';passed=$false;detail=$_.Exception.Message} }
  try { $t=Get-SLINTone 'this is urgent'; $tests += [pscustomobject]@{name='tone';passed=($null -ne $t.tone);detail=$t.tone} } catch { $tests += [pscustomobject]@{name='tone';passed=$false;detail=$_.Exception.Message} }
  $pass=(@($tests|? passed).Count -eq $tests.Count)
  [pscustomobject]@{passed=$pass;tests=$tests;timestamp=(Get-Date).ToString('o')}
}