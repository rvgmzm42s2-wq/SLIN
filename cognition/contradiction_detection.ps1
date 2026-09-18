function Find-SLINContradictions($Beliefs) {
  $out=@(); foreach($g in @($Beliefs)|Group-Object key){ $vals=@($g.Group|ForEach-Object {$_.value}|ForEach-Object { "$_" }|Select-Object -Unique); if($vals.Count -gt 1){$out+=[pscustomobject]@{key=$g.Name;values=$vals;type='possible_contradiction'}} }; $out
}
