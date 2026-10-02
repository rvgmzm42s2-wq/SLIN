param([string]$Model="qwen2.5:0.5b")
$ErrorActionPreference="Stop"
Write-Host ""
Write-Host "SLIN Local Model Setup"
Write-Host "======================"
$ollama=Get-Command ollama -ErrorAction SilentlyContinue
if(-not $ollama){
  $installer=Join-Path $env:TEMP "OllamaSetup.exe"
  Write-Host "Ollama is not installed. Downloading the local runtime..."
  Invoke-WebRequest "https://ollama.com/download/OllamaSetup.exe" -OutFile $installer
  Start-Process $installer -Wait
  $ollama=Get-Command ollama -ErrorAction SilentlyContinue
}
if(-not $ollama){$candidate=Join-Path $env:LOCALAPPDATA "Programs\Ollama\ollama.exe";if(Test-Path $candidate){$ollama=$candidate}}
if(-not $ollama){throw "Ollama could not be found. Restart PowerShell and run .\setup-model.ps1 again."}
Write-Host "Starting local model runtime..."
Start-Process -FilePath $ollama.Source -ArgumentList "serve" -WindowStyle Hidden -ErrorAction SilentlyContinue|Out-Null
Start-Sleep -Seconds 3
Write-Host "Downloading local model: $Model"
& $ollama.Source pull $Model
$slin=Join-Path $PSScriptRoot "config"
New-Item -ItemType Directory -Path $slin -Force|Out-Null
@{provider="ollama";endpoint="http://127.0.0.1:11434";model=$Model;temperature=0.7;context=2048;max_tokens=512}|ConvertTo-Json|Set-Content (Join-Path $slin "model.json") -Encoding UTF8
Write-Host ""
Write-Host "SLIN local model is ready."
Write-Host "Run .\SLIN-APP.cmd to start SLIN."