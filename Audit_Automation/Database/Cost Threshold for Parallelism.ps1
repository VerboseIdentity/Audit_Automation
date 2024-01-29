Clear-Host
function Cost-Threshold-for-Parallelism{
        
    Write-Host "`nInspecting Cost Threshold for Parallelism:`n-----------------------------------------"

    $Query = "SET NOCOUNT ON;
    SELECT value as 'Cost Threshold for Parallelism'
    FROM sys.configurations 
    WHERE name = 'Cost Threshold for Parallelism'
    "

    $config_data = Import-Clixml -Path .\Database\Config.xml
    $username = $config_data.sql_Username
    $password = $config_data.sql_Password
    $instance = $config_data.sql_instance
    $Servers = Get-content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]

            $output = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:username -Password $Using:password -Query $Using:Query
            }
            $prompt = "Server : $target"
            Write-Host "$prompt`n$('-'*$prompt.Length)"
            if ($output.'Cost Threshold for Parallelism' -eq 50) {
                Write-Host "Cost Threshold for Parallelism is set to 50`n" -ForegroundColor Green
            }
            else {
                Write-Host "Cost Threshold for Parallelism is set to", $output.'Cost Threshold for Parallelism' -ForegroundColor Red
                Write-Host "Please change the value to 50`n" -ForegroundColor Cyan
            }
        }
    }
}
Cost-Threshold-for-Parallelism