function Get-SLINLocalProviderStatus {
  $providers=@()
  foreach($name in @('ollama','llama-server','lmstudio')){
    $cmd=Get-Command $name -EA SilentlyContinue
    if($cmd){$providers+=$name}
  }
  [pscustomobject]@{available=($providers.Count -gt 0);providers=$providers;mode='local';note='Detection only. A provider must be explicitly configured before inference is used.'}
}
function Invoke-SLINLocalModel {
  param([Parameter(Mandatory)][string]$Prompt)
  $status=Get-SLINLocalProviderStatus
  if(!$status.available){return [pscustomobject]@{available=$false;text=$null;provider=$null;error='No supported local model provider detected.'}}
  [pscustomobject]@{available=$false;text=$null;provider=($status.providers -join ',');error='Provider detected but inference adapter is not configured.'}
}