function Get-SLINAffect([string]$Tone){
  $v=@{calm=.1;frustrated=-.6;excited=.7;serious=0;joking=.2;uncertain=-.1;urgent=-.1;affectionate=.8;neutral=0}
  $a=@{calm=.1;frustrated=.8;excited=.8;serious=.5;joking=.7;uncertain=.4;urgent=1;affectionate=.5;neutral=0}
  $val=0;$aro=0
  if($v.ContainsKey($Tone)){$val=$v[$Tone]}
  if($a.ContainsKey($Tone)){$aro=$a[$Tone]}
  [pscustomobject]@{tone=$Tone;valence=$val;arousal=$aro;source='heuristic'}
}
