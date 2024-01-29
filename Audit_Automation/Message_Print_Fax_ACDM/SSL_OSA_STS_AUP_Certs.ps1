
Clear-Host
function Get-SSL{

    $Servers = Get-Content -Path ".\Servers.txt"
    Write-host "`nListing SSL certificate Thumprints...`n------------------------------------" -ForegroundColor Yellow

    ForEach($Server in $Servers){

        if($Server.Split(",")[1] -eq "MSG" -or $Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX" -or $Server.Split(",")[1] -eq "ACDM"){

            $ServerName = $Server.Split(",")[0]
            Try{
                $Thumbprint = Invoke-Command -ComputerName $ServerName -ScriptBlock{(Get-WebBinding -Name "Default Web Site" -Protocol 'https' -Port '443').CertificateHash}
            }
            Catch{}

            [ordered]@{"$ServerName" = "$Thumbprint"}
        }
    }
}

function OSA{
    Write-Host "`nListing OSA Certificates....`n-----------------------------" -ForegroundColor Yellow
    $Servers = Get-Content -Path ".\Servers.txt"
    
    foreach($Server in $Servers){

        if($Server.Split(",")[1] -eq "MSG" -or $Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX" -or $Server.Split(",")[1] -eq "ACDM"){
            $target = $Server.Split(",")[0]
            $Cert = Invoke-Command -ComputerName $target -ScriptBlock {(Get-ChildItem -Path "Cert:\LocalMachine\My" |  Where-Object {$_.Subject -like "*OSA*"})}
            Write-Host "." -NoNewline
            $Output += @(
            [PSCustomObject]@{
            Server = "$target        "
            Thumbprint = $Cert.Thumbprint
            Validity = $Cert.NotAfter
            })
        }
    }
    $Output | Format-Table
}

function STS{

    Write-Host "`nListing STS Certificates....`n----------------------------" -ForegroundColor Yellow
    $Servers = Get-Content -Path ".\Servers.txt"
    foreach($Server in $Servers){

        if($Server.Split(",")[1] -eq "MSG" -or $Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX" -or $Server.Split(",")[1] -eq "ACDM"){
            $target = $Server.Split(",")[0]
            $Cert = Invoke-Command -ComputerName $target -ScriptBlock {(Get-ChildItem -Path "Cert:\LocalMachine\My" |  Where-Object {$_.Subject -like "*STS*"})}
            Write-Host "." -NoNewline
            $Output += @(
            [PSCustomObject]@{
            Server = "$target      "
            Thumbprint = $Cert.Thumbprint
            Validity = $Cert.NotAfter
            })
        }
    }
    $Output | Format-Table
}

function AUP{

    Write-Host "`nListing AUP Certificates....`n-----------------------------" -ForegroundColor Yellow
    $Servers = Get-Content -Path ".\Servers.txt"
    foreach($Server in $Servers){

        if($Server.Split(",")[1] -eq "MSG" -or $Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX" -or $Server.Split(",")[1] -eq "ACDM"){
            
            $target = $Server.Split(",")[0]
            $Cert = Invoke-Command -ComputerName $target -ScriptBlock {(Get-ChildItem -Path "Cert:\LocalMachine\My" |  Where-Object {$_.Subject -like "*AUP*"})}
            Write-Host "." -NoNewline
            $Output += @(
            [PSCustomObject]@{
            Server = "$target      "
            Thumbprint = $Cert.Thumbprint
            Validity = $Cert.NotAfter
            })
        }
    }
    $Output | Format-Table
}

Get-SSL
OSA
STS
AUP