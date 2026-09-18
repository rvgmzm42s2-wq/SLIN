function Start-SLINDesktop {
  try { Add-Type -AssemblyName PresentationFramework,PresentationCore,WindowsBase } catch { Start-SLINChat; return }
  $window=New-Object Windows.Window
  $window.Title='SLIN';$window.Width=900;$window.Height=650;$window.WindowStartupLocation='CenterScreen'
  $grid=New-Object Windows.Controls.Grid
  $row1=New-Object Windows.Controls.RowDefinition;$row1.Height='*'
  $row2=New-Object Windows.Controls.RowDefinition;$row2.Height='Auto'
  $grid.RowDefinitions.Add($row1);$grid.RowDefinitions.Add($row2)
  $chat=New-Object Windows.Controls.TextBox;$chat.IsReadOnly=$true;$chat.AcceptsReturn=$true;$chat.TextWrapping='Wrap';$chat.VerticalScrollBarVisibility='Auto';$chat.Margin='12'
  [Windows.Controls.Grid]::SetRow($chat,0);$grid.Children.Add($chat)
  $panel=New-Object Windows.Controls.DockPanel;$panel.Margin='12'
  $input=New-Object Windows.Controls.TextBox;$input.Height=38;$input.Margin='0,0,8,0'
  $send=New-Object Windows.Controls.Button;$send.Content='SEND';$send.Width=90;$send.Height=38
  [Windows.Controls.DockPanel]::SetDock($send,'Right');$panel.Children.Add($send);$panel.Children.Add($input)
  [Windows.Controls.Grid]::SetRow($panel,1);$grid.Children.Add($panel);$window.Content=$grid
  $nl=[Environment]::NewLine
  $chat.AppendText(('SLIN'+$nl+'Native cognition interface ready.'+$nl+$nl))
  $handler={
    if([string]::IsNullOrWhiteSpace($input.Text)){return}
    $q=$input.Text;$input.Clear();$chat.AppendText(('YOU: '+$q+$nl))
    if($q -eq '/status'){$x=Get-SLINSelfState;$chat.AppendText(($x|Out-String))}
    elseif($q -eq '/diagnose'){$x=Invoke-SLINDiagnostics;$chat.AppendText(($x|Out-String))}
    elseif($q -like '/remember *'){Add-SLINLongTerm $q.Substring(10);$chat.AppendText(('SLIN: remembered.'+$nl))}
    else{$x=Invoke-SLINConversation $q;$chat.AppendText(('SLIN ['+$x.tone+']: '+$x.text+$nl))}
    $chat.ScrollToEnd()
  }
  $send.Add_Click($handler);$input.Add_KeyDown({param($s,$e);if($e.Key -eq 'Enter'){$handler.Invoke()}})
  $window.ShowDialog()|Out-Null
}