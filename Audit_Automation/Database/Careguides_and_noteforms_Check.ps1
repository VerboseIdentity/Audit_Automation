Clear-Host

$Servers = Get-Content -Path ".\Servers.txt"
function Careguides {
    Write-Host "`nChecking CareGuides version...`n*******************************" -ForegroundColor Cyan
    $Query = "Select * from works..versionnumber WHERE VersionNumber like '%CareGuide%'"
    $data = Import-Clixml -Path .\Database\Config.xml
    $username = $data.sql_Username
    $password = $data.sql_Password
    $listener = $data.sql_instance

    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]
            $Careguides = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:listener -Username $Using:username -Password $Using:password -Query $Using:Query
            } 
        }
    }
    return $Careguides
}

function Noteform {
    Write-Host "`nChecking Noteforms version...`n******************************" -ForegroundColor Cyan
    $Query = "Select * from works..versionnumber WHERE VersionNumber like '%Noteform%'"
    $data = Import-Clixml -Path .\Database\Config.xml
    
    $username = $data.sql_Username
    $password = $data.sql_Password
    $listener = $data.sql_instance
    foreach($Server in $Servers){
        if ($Server.Split(",")[1] -eq "DB") {
            $target = $Server.Split(",")[0]
            $Noteforms = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:listener -Username $Using:username -Password $Using:password -Query $Using:Query
            }
        }
    }

    return $Noteforms
}

$Careguides_result = Careguides
$Careguides_result | Format-table
$Noteforms_result = Noteform
$Noteforms_result | Format-table