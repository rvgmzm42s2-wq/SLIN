Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Root=Split-Path -Parent $PSScriptRoot
$Modules=@(
    "SLIN.Core.ps1","SLIN.Json.ps1","SLIN.Logging.ps1","SLIN.State.ps1",
    "SLIN.Memory.ps1","SLIN.Tone.ps1","SLIN.Reasoning.ps1","SLIN.Session.ps1",
    "SLIN.Learning.ps1","SLIN.Cognition.ps1","SLIN.Sensors.ps1",
    "SLIN.Diagnostics.ps1","SLIN.SelfTest.ps1","SLIN.Report.ps1",
    "SLIN.Chat.ps1","SLIN.LocalModel.ps1"
)
foreach($module in $Modules){
    $file=Join-Path $Root "src\Modules\$module"
    if(Test-Path $file){. $file}
}
Initialize-SLIN -Root $Root

$form=New-Object System.Windows.Forms.Form
$form.Text="Silin"
$form.StartPosition="CenterScreen"
$form.Size=New-Object System.Drawing.Size(900,700)
$form.MinimumSize=New-Object System.Drawing.Size(700,520)
$form.BackColor=[System.Drawing.Color]::FromArgb(18,18,20)
$form.ForeColor=[System.Drawing.Color]::White

$header=New-Object System.Windows.Forms.Label
$header.Text="SILIN"
$header.Font=New-Object System.Drawing.Font("Segoe UI",22,[System.Drawing.FontStyle]::Bold)
$header.AutoSize=$true
$header.Location=New-Object System.Drawing.Point(22,18)
$form.Controls.Add($header)

$status=New-Object System.Windows.Forms.Label
$status.Text="Starting local AI..."
$status.Font=New-Object System.Drawing.Font("Segoe UI",10)
$status.AutoSize=$true
$status.Location=New-Object System.Drawing.Point(26,60)
$form.Controls.Add($status)

$chat=New-Object System.Windows.Forms.RichTextBox
$chat.ReadOnly=$true
$chat.BackColor=[System.Drawing.Color]::FromArgb(25,25,28)
$chat.ForeColor=[System.Drawing.Color]::White
$chat.BorderStyle="None"
$chat.Font=New-Object System.Drawing.Font("Segoe UI",11)
$chat.Location=New-Object System.Drawing.Point(22,90)
$chat.Size=New-Object System.Drawing.Size(840,485)
$chat.Anchor="Top,Bottom,Left,Right"
$form.Controls.Add($chat)

$input=New-Object System.Windows.Forms.TextBox
$input.Font=New-Object System.Drawing.Font("Segoe UI",11)
$input.BackColor=[System.Drawing.Color]::FromArgb(32,32,36)
$input.ForeColor=[System.Drawing.Color]::White
$input.BorderStyle="FixedSingle"
$input.Location=New-Object System.Drawing.Point(22,595)
$input.Size=New-Object System.Drawing.Size(700,38)
$input.Anchor="Bottom,Left,Right"
$form.Controls.Add($input)

$send=New-Object System.Windows.Forms.Button
$send.Text="Send"
$send.Font=New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$send.Location=New-Object System.Drawing.Point(735,594)
$send.Size=New-Object System.Drawing.Size(127,40)
$send.Anchor="Bottom,Right"
$form.Controls.Add($send)

$chat.AppendText("Silin is starting..." + [Environment]::NewLine + [Environment]::NewLine)
$chat.SelectionStart=$chat.TextLength
$chat.ScrollToCaret()

$busy=$false
$worker=New-Object System.ComponentModel.BackgroundWorker

function Set-Status([string]$text){$status.Text=$text}

function Start-ModelSetup {
    $setup=Join-Path $Root "setup-model.ps1"
    if(Test-Path $setup){
        Start-Process powershell.exe -ArgumentList @("-NoLogo","-NoProfile","-ExecutionPolicy","Bypass","-WindowStyle","Hidden","-File",$setup) -WindowStyle Hidden | Out-Null
    }
}

if(Test-SLINLocalModel){
    Set-Status "Local AI: ONLINE"
    $chat.AppendText("Silin: I'm here. Local AI, memory, context, reasoning, tone, learning, and diagnostics are active." + [Environment]::NewLine + [Environment]::NewLine)
} else {
    Set-Status "Local AI: SETTING UP..."
    $chat.AppendText("Silin: I'm getting the local AI system ready. You can keep this window open." + [Environment]::NewLine + [Environment]::NewLine)
    Start-ModelSetup
}

$timer=New-Object System.Windows.Forms.Timer
$timer.Interval=3000
$timer.Add_Tick({
    if(Test-SLINLocalModel){
        Set-Status "Local AI: ONLINE"
        $timer.Stop()
        if($chat.Text -like "*getting the local AI system ready*"){
            $chat.AppendText("Silin: I'm ready." + [Environment]::NewLine + [Environment]::NewLine)
            $chat.SelectionStart=$chat.TextLength
            $chat.ScrollToCaret()
        }
    }
})
if(-not (Test-SLINLocalModel)){$timer.Start()}

function Send-Message {
    if($script:busy){return}
    $text=$input.Text.Trim()
    if([string]::IsNullOrWhiteSpace($text)){return}
    if(-not (Test-SLINLocalModel)){
        $chat.AppendText("Silin: The local model is still starting. I'm not going to give you a fallback bot response." + [Environment]::NewLine + [Environment]::NewLine)
        $chat.SelectionStart=$chat.TextLength
        $chat.ScrollToCaret()
        return
    }
    $script:busy=$true
    $send.Enabled=$false
    $input.Enabled=$false
    $chat.AppendText("You: $text" + [Environment]::NewLine + [Environment]::NewLine)
    $chat.SelectionStart=$chat.TextLength
    $chat.ScrollToCaret()
    $worker.RunWorkerAsync($text)
}

$worker.DoWork += {
    param($sender,$e)
    try {$e.Result=Get-SLINConversationResponse -Text ([string]$e.Argument)}
    catch {$e.Result="Silin encountered a local runtime error: $($_.Exception.Message)"}
}
$worker.RunWorkerCompleted += {
    param($sender,$e)
    $response=[string]$e.Result
    if($response -eq "__EXIT__"){$form.Close();return}
    $chat.AppendText("Silin: $response" + [Environment]::NewLine + [Environment]::NewLine)
    $chat.SelectionStart=$chat.TextLength
    $chat.ScrollToCaret()
    $input.Clear()
    $input.Enabled=$true
    $send.Enabled=$true
    $script:busy=$false
    $input.Focus()
}

$send.Add_Click({Send-Message})
$input.Add_KeyDown({
    param($sender,$e)
    if($e.KeyCode -eq [System.Windows.Forms.Keys]::Enter -and -not $e.Shift){
        $e.SuppressKeyPress=$true
        Send-Message
    }
})
$form.Add_FormClosing({
    $timer.Stop()
    if($worker.IsBusy){$worker.CancelAsync()}
})
$input.Focus()
[System.Windows.Forms.Application]::Run($form)
