Clear-Host

function Get-Recommendations-works{

    Write-Host "`nChecking Get-Recommandations-Works job status..`n************************************************"

    $Query = "SELECT 
    [Name]
    ,[Enabled]
    FROM [msdb].[dbo].[sysjobs] Where name like '%Get Recommendations - Works%'"
            
    $config_data = Import-Clixml -Path .\Database\Config.xml
    $Username = $config_data.sql_Username
    $password = $config_data.sql_Password
    $instance = $config_data.sql_instance
    $Servers = Get-content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]

            $output = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:Username -Password $Using:password -Query $Using:Query
            }
            $output_table = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:Username -Password $Using:password -Query $Using:Query | Out-String
            }
            $prompt = "Server : $target"
            Write-Host "$prompt`n$('-'*$prompt.Length)"
            if($output.enabled -eq 0){
        
                Write-Host "Get-Recommendations Job is already disabled.`n" -ForegroundColor Green
                write-Host $output_table -ForegroundColor Green
            }
            else {
                Write-Host "Get-Recommendations Job is not disabled.`n" -ForegroundColor Red
                write-Host $output_table -ForegroundColor Red
            }
        }
    }
}
Get-Recommendations-works