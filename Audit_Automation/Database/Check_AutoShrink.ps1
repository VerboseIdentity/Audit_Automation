Clear-Host
function Auto-Shrink{
        
    Write-Host "`nChecking AutoShrink Status:`n---------------------------"

    $Query = "SELECT [name] AS DatabaseName
    , CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoClose')) AS AutoClose
    , CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoShrink')) AS AutoShrink
    FROM master.dbo.sysdatabases
    Order By DatabaseName;"

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
            $Disabled = $output | Select-Object DatabaseName, AutoClose, AutoShrink | Where-Object {$_.AutoShrink -match '0'} | Out-String
            $Enabled = $output | Select-Object DatabaseName, AutoClose, AutoShrink | Where-Object {$_.AutoShrink -notmatch '0'} | Out-String

            if($Enabled){
                Write-Host "AutoShrink for the below database(s) is enabled."
                Write-Host $Enabled -ForegroundColor Red
                Write-Host "Please Disable the AutoShrink"
            }
            else {
                Write-Host "AutoShrink is disabled on all the databases."
                Write-Host $Disabled -ForegroundColor Green
            }
        }
        break
    }
}
Auto-Shrink