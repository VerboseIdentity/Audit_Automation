Clear-Host

$Query = "SELECT job_id,[name],[enabled]
FROM [msdb].[dbo].[sysjobs] where [name] like '%MERT%'"

  function MERT-Sync{
    $Servers = Get-Content -Path ".\Servers.txt"
    $header = "Checking MERT-Sync Job Status"
    Write-Host "$header`n$('*'*$header.Length)"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $Config_data = Import-Clixml -Path ".\Database\Config.xml"
            $Username = $Config_data.sql_Username
            $Password = $Config_data.sql_Password
            $Instance = $Config_data.sql_instance
            $target = $Server.split(",")[0]
            $Output = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Instance -Query $Using:Query
            }
            $One = Invoke-Command -ComputerName $target -ScriptBlock {
                Invoke-Sqlcmd -ServerInstance $Instance -Query "Select * from Works..ahspreference where [key] in ('StructuredContentWorkshopSingleSignOnUrl')"
            }

            $Two = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Instance -Query "Select * from Works..ahspreference where [key] in ('StructuredContentWorkshopURL')"
                }
            
            if ($Output.enabled -ne 0) {
                Write-Host "MERT Sync Job is NOT disabled" -ForegroundColor Red
                $Output | Format-Table
            }
            else {
                Write-Host "MERT Sync Job is disabled.." -ForegroundColor Green
                $Output | Format-Table
            }
            if ($One.Value -eq '') {
                Write-Host "[StructuredContentWorkshopSingleSignOnUrl] is Null" -ForegroundColor Green
                $One | Format-Table
            }
            else {
                Write-Host "[StructuredContentWorkshopSingleSignOnUrl] is NOT Null" -ForegroundColor Red
                $One | Format-Table
            }
            if ($Two.Value -eq '') {
                Write-Host "[StructuredContentWorkshopURL] is Null" -ForegroundColor Green
                $Two | Format-Table
            }
            else {
                Write-Host "[StructuredContentWorkshopURL] is NOT Null" -ForegroundColor Red
                $Two | Format-Table
            }
            break
        }
    }
}
MERT-Sync