Clear-Host

function Service-check{
    $header = "Checking for Print and Fax related service status.."
    Write-Host "$header`n$('*'*$header.Length)"
    $Servers = Get-Content -Path .\Servers.txt
    foreach($Server in $Servers){
        if ($Server.Split(",")[1] -eq "MSG" -or $Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX" -or $Server.Split(",")[1] -eq "ACDM") {
            $target = $Server.Split(",")[0]
            $Services = Get-Service -ComputerName $target -DisplayName "TWMessageCenterSpooler","TWFaxJobStatusUpdateService","Printer Extensions and Notifications","Print Spooler" | format-table -AutoSize
            $prompt = "Server : $target"
            Write-Host "$prompt`n$('-'*$prompt.Length)" -ForegroundColor Magenta
            $Services
        }
    }
}
Service-check