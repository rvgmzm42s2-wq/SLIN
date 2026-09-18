$script:SLINConversation = [ordered]@{tone='neutral';urgency=0;turn=0}
function Update-SLINConversationState([string]$Tone,[int]$Urgency=0) { $script:SLINConversation.tone=$Tone; $script:SLINConversation.urgency=$Urgency; $script:SLINConversation.turn++; [pscustomobject]$script:SLINConversation }
function Get-SLINConversationState { [pscustomobject]$script:SLINConversation }
