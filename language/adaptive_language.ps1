function ConvertTo-SLINResponseStyle {
  param([string]$Text,[string]$Tone='neutral')
  if(!$Text){return ''}
  switch($Tone){
    'frustrated' { return $Text.Trim() }
    'urgent' { return $Text.Trim() }
    'excited' { return $Text.Trim() }
    'affectionate' { return $Text.Trim() }
    default { return $Text.Trim() }
  }
}