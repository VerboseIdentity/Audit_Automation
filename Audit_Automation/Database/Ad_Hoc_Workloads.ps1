Clear-Host

function Ad-Hoc-Workloads{

    Write-Host "`nChecking Ad-Hoc Workflow status`n-------------------------------"
    $config_data = Import-Clixml -Path .\Database\Config.xml

    $Username = $config_data.sql_Username
    $Password = $config_data.sql_Password
    $instance = $config_data.sql_instance

    $Query = "EXEC sp_configure @configname='optimize for ad hoc workloads';"

    $Servers = Get-content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]
        
            $output = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:Username -Password $Using:Password -Query $Using:Query
            }

            $output_Table = Invoke-command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:Username -Password $Using:Password -Query $Using:Query | Format-Table | Out-String
            }

            if($output.config_value -eq 1 -and $output.maximum -eq 1 -and $output.run_value -eq 1){
                Write-Host "Ad-Hoc Workloads Optimized."
                Write-Host $output_Table -ForegroundColor Green
            }
            else{
                Write-Host "Ad-Hoc Workloads not Optimized."
                Write-Host $output_Table -ForegroundColor Red
            }
        }
        break
    }

}
Ad-Hoc-Workloads