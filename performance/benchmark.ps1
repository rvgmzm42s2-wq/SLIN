function Invoke-SLINBenchmark {
  param([int]$Iterations=3)
  if($Iterations -lt 1){$Iterations=1}; if($Iterations -gt 10){$Iterations=10}
  $rows=@()
  1..$Iterations|%{
    $sw=[Diagnostics.Stopwatch]::StartNew(); Get-SLINCPUPerformance|Out-Null; $sw.Stop()
    $rows += [pscustomobject]@{test='cpu-query';milliseconds=$sw.ElapsedMilliseconds}
    $sw.Restart(); Get-SLINMemoryPerformance|Out-Null; $sw.Stop()
    $rows += [pscustomobject]@{test='memory-query';milliseconds=$sw.ElapsedMilliseconds}
    $sw.Restart(); Get-SLINStoragePerformance|Out-Null; $sw.Stop()
    $rows += [pscustomobject]@{test='storage-query';milliseconds=$sw.ElapsedMilliseconds}
  }
  [pscustomobject]@{iterations=$Iterations;results=$rows;timestamp=(Get-Date).ToString('o')}
}