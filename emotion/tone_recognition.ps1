function Get-SLINTone([string]$Text) {
  $t=$Text.ToLowerInvariant();$scores=@{calm=0;frustrated=0;excited=0;serious=0;joking=0;uncertain=0;urgent=0;affectionate=0;neutral=1}
  if($t -match 'fuck|shit|damn|angry|frustrat'){$scores.frustrated+=3}
  if($t -match '!{1,}|excited|awesome|yes'){$scores.excited+=2}
  if($t -match 'urgent|asap|immediately|now'){$scores.urgent+=4}
  if($t -match 'maybe|not sure|wonder|uncertain|could'){$scores.uncertain+=2}
  if($t -match 'lol|haha|😂|🤣|joke|kidding'){$scores.joking+=3}
  if($t -match 'love|thank you|thanks|❤️|❤'){$scores.affectionate+=2}
  if($t -match 'important|serious|critical|warning'){$scores.serious+=2}
  if($t -match 'calm|relax|all good|no rush'){$scores.calm+=2}
  $best=$scores.GetEnumerator()|Sort-Object Value -Descending|Select-Object -First 1
  [pscustomobject]@{tone=$best.Key;scores=$scores;heuristic=$true}
}