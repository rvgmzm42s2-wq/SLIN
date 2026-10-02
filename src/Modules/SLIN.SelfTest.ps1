function Invoke-SLINSelfTest {
    $results = @()

    function Add-Test {
        param([string]$Name,[bool]$Pass,[string]$Detail)
        $script:results += [pscustomobject]@{
            Test=$Name
            Pass=$Pass
            Detail=$Detail
        }
    }

    foreach($p in @("config","data","logs","reports","runtime")){
        $path=Get-SLINPath $p
        Add-Test "Path:$p" (Test-Path $path) $path
    }

    try {
        $p=Get-SLINPath "data\selftest.json"
        Write-SLINJson $p ([pscustomobject]@{ok=$true})
        $x=Read-SLINJson $p $null
        Add-Test "JSON read/write" ($null -ne $x -and $x.ok -eq $true) "round trip"
        Remove-Item $p -Force -ErrorAction SilentlyContinue
    } catch {
        Add-Test "JSON read/write" $false $_.Exception.Message
    }

    try {
        $o=Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
        Add-Test "CIM OS" $true $o.Caption
    } catch {
        Add-Test "CIM OS" $false $_.Exception.Message
    }

    try {
        $d=Get-SLINDiagnostics
        Add-Test "Diagnostics" ($null -ne $d) "query completed"
    } catch {
        Add-Test "Diagnostics" $false $_.Exception.Message
    }

    try {
        $s=@(Get-SLINSensors)
        Add-Test "Sensor discovery" ($s.Count -gt 0) "safe probe"
    } catch {
        Add-Test "Sensor discovery" $false $_.Exception.Message
    }

    return @($results)
}
