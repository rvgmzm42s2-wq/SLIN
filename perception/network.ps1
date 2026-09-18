function Get-SLINNetworkPerception{Get-CimInstance Win32_NetworkAdapterConfiguration -Filter 'IPEnabled=TRUE'|select Description,IPAddress,DefaultIPGateway,DNSServerSearchOrder}
