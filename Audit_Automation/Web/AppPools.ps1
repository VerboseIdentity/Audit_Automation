Clear-Host

$Servers = Get-Content -Path ".\Servers.txt"

function AppPool_Status{
    Write-Host "Checking AppPool Status`n***********************"
    foreach ($Server in $Servers) {
        if ($Server.Split(",")[1] -eq "WEB" -or $Server.Split(",")[1] -eq "MSG") {
            $target = $Server.Split(",")[0]
            $prompt = "Collecting AppPools on [$target]"
            Write-Output "$prompt`n$('-'*$prompt.Length)"
    
            try {
                $AppPools = Invoke-Command -ComputerName $target -ScriptBlock {
                    Get-IISAppPool
                } -ErrorAction Stop
    
                $ja = Invoke-Command -ComputerName $target -ScriptBlock {
                    $appPool = Get-IISAppPool | Where-Object { $_.Name -eq 'ScanWeb Pool' }
                    Write-Output "Found AppPool: $($appPool.Name)`nRunning with"
                    $appPool.ProcessModel.UserName
                }

                $stoppedPools = $AppPools | Where-Object { $_.State -eq 'Stopped'}
                if ($stoppedPools) {
                    Write-Host "`nBelow AppPool(s) are not running`n" -ForegroundColor Red
                    Write-Host $stoppedPools.Name -ForegroundColor Red
                    Write-Host ""
                    Write-Host "$ja`n" -ForegroundColor Cyan
                }
                else {
                    Write-Host "`nAll the AppPools are running`n" -ForegroundColor Green
                    Write-Host "$ja`n" -ForegroundColor Cyan
                }
            } catch {
                Write-Output "Error collecting AppPools on $target $_"
            }
        }
    }
}
AppPool_Status