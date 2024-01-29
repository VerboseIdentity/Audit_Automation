Clear-Host
function ATP_Version_Check{

    Write-Host "`nChecking ATP version...`n***********************"

    $Query = "use TermRuntimeDB
    select dbo.SymedicalDBVersion ()"

    $data = Import-Clixml -Path .\Database\Config.xml

    $username = $data.sql_Username
    $password = $data.sql_Password
    $instance = $data.sql_instance

    $Servers = Get-Content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]
            $ATPVersion = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:username -Password $Using:password -Query $Using:Query
            }

        if ($ATPVersion.Column1 -eq "2.0.1.15"){

        Write-Host "ATP DB is on the correct version",$ATPVersion.Column1`n -ForegroundColor Green
        }
        else{
            Write-Host "ATP DB is not on the correct version",$ATPVersion.Column1`n -ForegroundColor Red
            }
        }
        break
    }
}

function Check_ATP_Packages {
    Write-Host "Checking ATP packages..`n************************"
    $Query = "SELECT * FROM TermRuntimeDB..SvrRTPackageQueue where PackageApplicationStatusID  not in (4,5) ORDER BY PackageDate DESC;"

    $data = Import-Clixml -Path .\Database\Config.xml

    $username = $data.sql_Username
    $password = $data.sql_Password
    $instance = $data.sql_instance

    $Servers = Get-Content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if($Server.split(",")[1] -eq "DB"){
            $target = $Server.split(",")[0]
            $ATPpackages = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:username -Password $Using:password -Query $Using:Query
            }

            if ($ATPpackages){
        
                Write-Host "ATP Packages not completed.`n" -ForegroundColor Red
            }
            else {
                Write-Host "ATP Packages successfully completed.`n" -ForegroundColor Green
            }
        }
        break
    }
}

ATP_Version_Check
Check_ATP_Packages