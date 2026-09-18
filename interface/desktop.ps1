function Start-SLINDesktop {
  try { Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase } catch { Start-SLINChat; return }

  $window=New-Object Windows.Window
  $window.Title='SLIN — Sovereign Windows System'
  $window.Width=900
  $window.Height=650
  $window.WindowStartupLocation='CenterScreen'

  $grid=New-Object Windows.Controls.Grid
  $row1=New-Object Windows.Controls.RowDefinition;$row1.Height='*'
  $row2=New-Object Windows.Controls.RowDefinition;$row2.Height='Auto'
  $grid.RowDefinitions.Add($row1);$grid.RowDefinitions.Add($row2)

  $chat=New-Object Windows.Controls.TextBox
  $chat.IsReadOnly=$true;$chat.AcceptsReturn=$true;$chat.TextWrapping='Wrap'
  $chat.VerticalScrollBarVisibility='Auto';$chat.Margin='12'
  [Windows.Controls.Grid]::SetRow($chat,0);$grid.Children.Add($chat)

  $panel=New-Object Windows.Controls.DockPanel;$panel.Margin='12'
  $input=New-Object Windows.Controls.TextBox;$input.Height=38;$input.Margin='0,0,8,0'
  $send=New-Object Windows.Controls.Button;$send.Content='SEND';$send.Width=90;$send.Height=38
  [Windows.Controls.DockPanel]::SetDock($send,'Right')
  $panel.Children.Add($send);$panel.Children.Add($input)
  [Windows.Controls.Grid]::SetRow($panel,1);$grid.Children.Add($panel)
  $window.Content=$grid

  $nl=[Environment]::NewLine
  $chat.AppendText(('SLIN — Sovereign Windows System'+$nl+'Native cognition online. No external AI provider.'+$nl+$nl))

  $handler={
    if([string]::IsNullOrWhiteSpace($input.Text)){return}
    $q=$input.Text;$input.Clear();$chat.AppendText(('YOU: '+$q+$nl))

    switch -Regex($q){
      '^/exit$' {$window.Close();return}
      '^/help$' {$chat.AppendText(('/status /diagnose /remember <text> /recall <text> /selftest /benchmark /report /native /patterns /exit'+$nl));break}
      '^/status$' {$chat.AppendText((Get-SLINSelfState|Out-String));break}
      '^/diagnose$' {$chat.AppendText((Invoke-SLINDiagnostics|Out-String));break}
      '^/native$' {$chat.AppendText((Get-SLINNativeStatus|Out-String));break}
      '^/patterns$' {$chat.AppendText((Get-SLINLearnedPatterns|Out-String));break}
      '^/selftest$' {$chat.AppendText((Invoke-SLINSelfTest|Out-String));break}
      '^/benchmark$' {$chat.AppendText((Invoke-SLINBenchmark|Out-String));break}
      '^/report$' {$chat.AppendText((Export-SLINReport|Out-String));break}
      '^/remember ' {Add-SLINLongTerm ($q.Substring(10));$chat.AppendText(('SLIN: remembered.'+$nl));break}
      '^/recall ' {$chat.AppendText((Search-SLINMemory ($q.Substring(8))|Out-String));break}
      default {$x=Invoke-SLINConversation $q;$chat.AppendText(('SLIN ['+$x.tone+']: '+$x.text+$nl))}
    }
    $chat.ScrollToEnd()
  }

  $send.Add_Click($handler)
  $input.Add_KeyDown({param($s,$e);if($e.Key -eq 'Enter'){$handler.Invoke()}})
  $window.ShowDialog()|Out-Null
}
