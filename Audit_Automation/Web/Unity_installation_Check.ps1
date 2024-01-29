Clear-Host
function Unity{

    $header = "`nUnity Installation Check:"
    Write-Host "$header`n$('-'*$header.length)"
    $Servers = Get-Content -Path .\Servers.txt

    foreach($Server in $Servers){

        if($Server.Split(",")[1] -eq "UNITY"){

            $target = $Server.Split(",")[0]
            $Unity_AppPool = Invoke-Command -ComputerName $target -ScriptBlock{

                Get-IISAppPool | Select Name,AutoStart,State | Where-Object Name -Like *UnityAppPool*
            } | Out-String

            if ($Unity_AppPool) {
                Write-Host "Unity Installed, AppPool Available"
                Write-Host "$Unity_AppPool`n" -ForegroundColor Green
                $pool = 'UnityAppPool'
                $appPool = Get-WmiObject -Namespace "root\WebAdministration" -Class "ApplicationPool" -Filter "Name='$pool'"
                $identityType = $appPool.ProcessModel.IdentityType
                $accountName = switch ($identityType) {
                0 { "LocalSystem" }
                1 { "LocalService" }
                2 { "NetworkService" }
                3 { $appPool.ProcessModel.UserName }
                4 { "ApplicationPoolIdentity" }
                default { "Unknown" }
                }
            
                Write-Host "Unity AppPool is running on $accountName"
            
            }
            else {
                Write-Host "Unity is NOT Installed, AppPool NOT found`n" -ForegroundColor Red
            }
        }
    }
}
Unity