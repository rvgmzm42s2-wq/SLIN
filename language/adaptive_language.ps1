function ConvertTo-SLINResponseStyle {
  param([string]$Text,[string]$Tone='neutral')
  if(!$Text){return ''}
  switch($Tone){
    'urgent' { return $Text.Trim() }
    'frustrated' { return $Text.Trim() }
    'excited' { return $Text.Trim() }
    'affectionate' { return $Text.Trim() }
    default { return $Text.Trim() }
  }
}