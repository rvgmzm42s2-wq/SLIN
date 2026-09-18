function Invoke-SLINSelfTest {
  $tests=@()

  $tests += [pscustomobject]@{
    name='root'
    passed=(Test-Path (Get-SLINRoot))
    detail=(Get-SLINRoot)
  }
  $tests += [pscustomobject]@{
    name='config'
    passed=(Test-Path (Get-SLINPath 'config/slin.json'))
    detail=(Get-SLINPath 'config/slin.json')
  }
  $tests += [pscustomobject]@{
    name='data'
    passed=(Test-Path (Get-SLINPath 'data'))
    detail='Local data directory accessible'
  }

  try {
    $null=Get-SLINLongTerm
    $tests += [pscustomobject]@{name='memory';passed=$true;detail='Long-term memory accessible'}
  } catch {
    $tests += [pscustomobject]@{name='memory';passed=$false;detail=$_.Exception.Message}
  }

  try {
    $d=Invoke-SLINDiagnostics
    $tests += [pscustomobject]@{
      name='diagnostics'
      passed=($null -ne $d.system -and $null -ne $d.cpu)
      detail='Core diagnostics returned'
    }
  } catch {
    $tests += [pscustomobject]@{name='diagnostics';passed=$false;detail=$_.Exception.Message}
  }

  try {
    $t=Get-SLINTone 'this is urgent'
    $tests += [pscustomobject]@{name='tone';passed=($null -ne $t.tone);detail=$t.tone}
  } catch {
    $tests += [pscustomobject]@{name='tone';passed=$false;detail=$_.Exception.Message}
  }

  try {
    $ctx=[pscustomobject]@{
      userText='Can you diagnose this problem?'
      tone='serious'
      memory=@()
      beliefs=@()
      contradictions=@()
      facts=@()
      goals=@()
      observations=@()
    }
    $d=Invoke-SLINDecisionLoop $ctx
    $response=Invoke-SLINNativeResponse -Text $ctx.userText -Context $ctx -Decision $d
    $tests += [pscustomobject]@{
      name='native-cognition'
      passed=($d.intent -eq 'diagnostic' -and -not [string]::IsNullOrWhiteSpace($response))
      detail=('intent='+$d.intent+'; action='+$d.decision)
    }
  } catch {
    $tests += [pscustomobject]@{name='native-cognition';passed=$false;detail=$_.Exception.Message}
  }

  try {
    $patterns=@(Get-SLINLearnedPatterns)
    $tests += [pscustomobject]@{name='learning';passed=$true;detail=('patterns='+$patterns.Count)}
  } catch {
    $tests += [pscustomobject]@{name='learning';passed=$false;detail=$_.Exception.Message}
  }

  $pass=(@($tests|Where-Object {$_.passed}).Count -eq $tests.Count)
  [pscustomobject]@{
    passed=$pass
    tests=$tests
    timestamp=(Get-Date).ToUniversalTime().ToString('o')
  }
}
