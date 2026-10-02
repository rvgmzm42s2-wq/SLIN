param([string]$Model="qwen2.5:0.5b")
$ErrorActionPreference="Stop"
Write-Host ""
Write-Host "SLIN Local Model Setup"
Write-Host "======================"

$ollama=Get-Command ollama -ErrorAction SilentlyContinue
if(-not $ollama){
  $installer=Join-Path $env:TEMP "OllamaSetup.exe"
  Write-Host "Ollama is not installed. Downloading the local runtime..."
  $curl=Get-Command curl.exe -ErrorAction SilentlyContinue
  if($curl){
    & $curl.Source "-L" "--fail" "--retry" "3" "--retry-delay" "2" "-o" $installer "https://ollama.com/download/OllamaSetup.exe"
    if($LASTEXITCODE -ne 0){throw "Ollama download failed with curl exit code $LASTEXITCODE."}
  } else {
    Start-BitsTransfer -Source "https://ollama.com/download/OllamaSetup.exe" -Destination $installer
  }
  if(-not(Test-Path $installer)){throw "Ollama installer was not downloaded."}
  Write-Host "Installing Ollama..."
  Start-Process $installer -Wait
  $ollama=Get-Command ollama -ErrorAction SilentlyContinue
}
if(-not $ollama){
  $candidates=@(
    (Join-Path $env:LOCALAPPDATA "Programs\Ollama\ollama.exe"),
    (Join-Path $env:LOCALAPPDATA "Ollama\ollama.exe")
  )
  foreach($candidate in $candidates){
    if(Test-Path $candidate){$ollama=Get-Item $candidate;break}
  }
}
if(-not $ollama){throw "Ollama could not be found after installation. Restart PowerShell and run .\setup-model.ps1 again."}

$ollamaPath=$ollama.Source
if(-not $ollamaPath){$ollamaPath=$ollama.Path}
Write-Host "Starting local model runtime..."
Start-Process -FilePath $ollamaPath -ArgumentList "serve" -WindowStyle Hidden -ErrorAction SilentlyContinue|Out-Null
Start-Sleep -Seconds 3
Write-Host "Downloading local model: $Model"
& $ollamaPath pull $Model
if($LASTEXITCODE -ne 0){throw "Ollama could not download the model. Exit code: $LASTEXITCODE."}

$slin=Join-Path $PSScriptRoot "config"
New-Item -ItemType Directory -Path $slin -Force|Out-Null
@{provider="ollama";endpoint="http://127.0.0.1:11434";model=$Model;temperature=0.7;context=2048;max_tokens=512}|ConvertTo-Json|Set-Content (Join-Path $slin "model.json") -Encoding UTF8
Write-Host ""
Write-Host "SLIN local model is ready."
Write-Host "Run .\SLIN-APP.cmd to start SLIN."
