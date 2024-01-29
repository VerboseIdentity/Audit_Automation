Clear-Host
function Old_CED_Jobs {
    Write-Host "`nChecking Old CED jobs status...`n*******************************"

    $Query = "SELECT TOP (1000) [job_id]
    ,[name]
    ,[enabled]
    FROM [msdb].[dbo].[sysjobs] where name in ('Invoke CED generation', 'Invoke CED Submission', 'Invoke CED Submission Day')"

    $data = Import-Clixml -Path .\Database\Config.xml
    
    $username = $data.sql_Username
    $password = $data.sql_Password
    $instance = $data.sql_instance
    $Servers = Get-Content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if($Server.split(",")[1] -eq "DB"){
            $target = $Server.split(",")[0]

            Invoke-Command -ComputerName $target -ScriptBlock{
                $Old_CED_Jobs = Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:username -Password $Using:password -Query $Using:Query
            }
        }
    }
    
    if($Old_CED_Jobs_result){
        Write-Host "Old CED jobs are not deleted.`n" -ForegroundColor Red
        $Old_CED_Jobs_result | Format-Table
        }
        else {
        Write-Host "Old CED Jobs already deleted, not available.`n" -ForegroundColor Green
    }
    
}

Old_CED_Jobs