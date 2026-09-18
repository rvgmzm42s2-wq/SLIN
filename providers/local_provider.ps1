function Get-SLINNativeStatus {
  [pscustomobject]@{
    mode='native'
    externalDependencies=$false
    inference='SLIN-native'
    learning='self-observation-outcome'
    status='active'
    note='SLIN operates without an external AI provider.'
  }
}
