function Get-SLINResponseCalibration([string]$Tone) {
  $m=@{frustrated='direct';urgent='action-first';uncertain='clarifying';joking='light';affectionate='warm';serious='focused';excited='energetic';calm='calm';neutral='neutral'}
  [pscustomobject]@{input_tone=$Tone;response_mode=($m[$Tone] ?? 'neutral')}
}
