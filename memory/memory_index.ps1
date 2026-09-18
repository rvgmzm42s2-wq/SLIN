function Search-SLINMemory([string]$Query){
  if([string]::IsNullOrWhiteSpace($Query)){return @()}
  $terms=$Query -split '\s+'|?{$_}|%{[regex]::Escape($_)}
  $results=@()
  foreach($n in @('long-term.jsonl','episodes.jsonl','semantic.jsonl')){
    $p=Join-Path $script:SLINRoot ('data/'+$n)
    if(Test-Path $p){foreach($line in Get-Content $p){if($terms|?{$line -match $_}){try{$results+=$line|ConvertFrom-Json}catch{}}}}
  }
  @($results|Select-Object -Last 50)
}