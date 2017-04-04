#ping test. default destination is gateway.

param
(
    $des = (Get-NetIPConfiguration).IPv4DefaultGateway[0].NextHop,
    $t1 = 10,
    $t2 = 100,
    $p = 1000,
    $cyc = -1
)

$t1Cnt = $t2Cnt = $toutCnt = $pingCnt = 0
$StartT = Get-Date
$StartTime = $StartT.ToString("yyyy-MM-dd HH:mm:ss:ff")

Write-Host "`n//------------------------------------------------------//`n"
Write-Host "Pinging $des, started at $StartTime. `n"

while(1)
{
    $rt = (Test-Connection $des -Count 1).ResponseTime
    $pingCnt = $pingCnt + 1

    if($rt -le $t1){$t1Cnt = $t1Cnt + 1}
    elseif($rt -le $t2){$t2Cnt = $t2Cnt + 1}
    else
    {
        $toutCnt = $toutCnt + 1
        Write-Host "`r                                                                                                           " -NoNewline
        Write-Host "`r$toutCnt timeout at $(Get-Date -Format "yyyy-MM-dd HH:mm:ss:ff")"
    }

    $lost = ($toutCnt/$pingCnt * 100).ToString("F2")

    Write-Host "`r    $pingCnt " -ForegroundColor white -NoNewline
    Write-Host "pings:  " -NoNewline
    Write-Host "$t1Cnt " -ForegroundColor green -NoNewline
    Write-Host "<$t1 ms; " -NoNewline
    Write-Host "$t2Cnt " -ForegroundColor yellow -NoNewline
    Write-Host "<$t2 ms; " -NoNewline
    Write-Host "$toutCnt " -ForegroundColor red -NoNewline
    Write-Host ">$t2 ms. " -NoNewline
    Write-Host "$lost% " -ForegroundColor red -NoNewline
    Write-Host "lost. " -NoNewline

    if($cyc -gt 0)
    {
        $cyc = $cyc -1
        if($cyc -eq 0) {break}
    }

    Start-Sleep -Milliseconds $p
}

$ts = New-TimeSpan -Start $StartT -End $(Get-Date)

Write-Host "`n`n$toutCnt($lost%) of $pingCnt pings timeout in $ts. "
Write-Host "//------------------------------------------------------//`n"
