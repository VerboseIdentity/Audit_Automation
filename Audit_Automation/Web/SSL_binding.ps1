Clear-Host
function Get-SSL{

    $Servers = Get-Content -Path ".\Servers.txt"
    Write-host "Listing SSL certificate Thumprints...`n------------------------------------" -ForegroundColor Yellow

    ForEach($Server in $Servers){

        if($Server.Split(",")[1] -eq "WEB"){

            $ServerName = $Server.Split(",")[0]
            Try{
                $Thumbprint = Invoke-Command -ComputerName $ServerName -ScriptBlock{(Get-WebBinding -Name "Default Web Site" -Protocol 'https' -Port '443').CertificateHash}
            }
            Catch{}

            [ordered]@{"$ServerName" = "$Thumbprint"}
        }
 
    }
    Write-Host "`n"
}

Get-SSL