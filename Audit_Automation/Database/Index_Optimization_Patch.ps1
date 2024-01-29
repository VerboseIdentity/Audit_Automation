clear-Host
function Index-Optimization-patch{

    Write-Host "`nChecking Index-Optimization-patch Status`n-----------------------------------------"
    $Query1 = "Select * from WORKS..zzzNonDictionaryTables where isnull(startdttm, '') = '' or isnull(enddttm,'') = '';"
    $Query2 = "Select * from WORKS..zzzdictionarytables where isnull(startdttm, '') = '' or isnull(enddttm,'') = '';"

    $config_data = Import-Clixml -Path .\Database\Config.xml
    $username = $config_data.sql_Username
    $password = $config_data.sql_Password
    $instance = $config_data.sql_instance
    $Servers = Get-content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]

            $Table1 = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:username -Password $Using:password -Query $Using:Query1 | Out-String
            }

            $Table2 = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $using:instance -Username $Using:username -Password $Using:password -Query $Using:Query2 | Out-String
            }
        
            if($Table1 -or $Table1){
        
                Write-Host "Index-Optimazation Patch is not installed."
                if($Table1){
                    Write-Host $Table1 -ForegroundColor Red
                }
                else {
                    Write-Host $Table2 -ForegroundColor Red
                } 
            }
            else {
                Write-Host "Index-Optimization Patch is installed.`n" -ForegroundColor Green
            }
        }
        break
    }
}
Index-Optimization-patch