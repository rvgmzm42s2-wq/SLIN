function Get-SLINLocalProviderStatus {
  $providers=@()
  foreach($name in @('ollama','llama-server','lmstudio')){ $cmd=Get-Command $name -EA SilentlyContinue; if($cmd){$providers+=$name} }
  [pscustomobject]@{available=($providers.Count -gt 0);providers=$providers;mode='local';note='Provider detection only; no model is downloaded or started automatically.'}
}