Clear-Host
function MAXDOP{
        
    Write-Host "`nInspecting MAX Degree of Parallelism:`n------------------------------------"

    $Query = "SET NOCOUNT ON;
    SELECT value as 'Max Degree of Parallelism'
    FROM sys.configurations 
    WHERE name = 'max degree of parallelism'
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
            if ($output.'Max Degree of Parallelism' -eq 2) {
                Write-Host "Max Degree of Parallelism is set to 2.`n" -ForegroundColor Green
            }
            else {
                Write-Host "Max Degree of parallelism is set to", $output.'Max Degree of Parallelism' -ForegroundColor Red
                Write-Host "Please change the value to 2.`n" -ForegroundColor Cyan
            }
        }
    }
}
MAXDOP