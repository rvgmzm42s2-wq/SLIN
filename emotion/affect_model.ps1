function Get-SLINAffect([string]$Tone) {
  $v=@{calm=0.1;frustrated=-0.6;excited=0.7;serious=0;joKing=0;uncertain=-0.1;urgent=-0.1;affectionate=0.8;neutral=0}
  $ar=@{calm=0.1;frustrated=0.8;excited=0.8;serious=0.5;joking=0.7;uncertain=0.4;urgent=1;affectionate=0.5;neutral=0}
  [pscustomobject]@{tone=$Tone;valence=($v[$Tone] ?? 0);arousal=($ar[$Tone] ?? 0);source='heuristic'}
}
