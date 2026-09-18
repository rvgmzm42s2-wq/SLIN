function Find-SLINPatterns($Observations) {
  @($Observations)|Group-Object|Sort-Object Count -Descending|ForEach-Object {[pscustomobject]@{pattern=$_.Name;count=$_.Count}}
}
