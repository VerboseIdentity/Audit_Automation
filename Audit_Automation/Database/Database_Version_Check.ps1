Clear-host

function Reading_config{

    $config_Data = Import-Clixml -Path .\Database\Config.xml
    
    return $config_Data

}

$data = Reading_config

function DBVersion_Check {

    param ($Creds)

    Write-Host "`nChecking Database Version:`n**************************" -Foregroundcolor Cyan
    $Servers = Get-Content -Path .\Servers.txt
    foreach ($Server in $Servers){
        if($Server.split(",")[1] -eq "DB"){
            $target = $Server.split(",")[0]
            $Username = $Creds.sql_username
            $Password = $Creds.sql_password
            $Listener = $Creds.sql_instance
            
            $Query = "Select * from works..Versionnumber where VersionNumber = '11.0.0'"
            $output = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:Listener -Username $Using:Username -Password $Using:Password -Query $Using:Query
            }
        }
        #break
    }
    return $output
}

$result = DBVersion_Check -Creds $data
$result | Format-List