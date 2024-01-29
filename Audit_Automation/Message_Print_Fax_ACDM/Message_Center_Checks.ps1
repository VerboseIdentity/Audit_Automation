Clear-Host
function Message-Center{

    $Servers = Get-Content -Path ".\Servers.txt"
    $header = "Message Center Component availablity and Status check.."
    Write-Host "$header`n$('*'*$header.Length)" -ForegroundColor Yellow

    ForEach($Server in $Servers){

        if($Server.Split(",")[1] -eq "MSG" -or $Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX" -or $Server.Split(",")[1] -eq "ACDM"){

            $ServerName = $Server.Split(",")[0]
            Try{
                $Component_Status = Invoke-Command -ComputerName $ServerName -ScriptBlock{Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher,DisplayVersion | Where {$_.DisplayName -like '*Message Center*'} | Sort-Object DisplayName | Format-Table DisplayName, Publisher,DisplayVersion}
                $Service_status = Invoke-Command -ComputerName $ServerName -ScriptBlock{
                    Get-Service -DisplayName TWMessageCenterSpooler
                }
            }
            Catch{Write-Host "Unable to connect or fetch any one of the details."}
            $Prompt = "Checking Status on [$ServerName]"
            Write-Host "$Prompt`n$('-'*$Prompt.Length)"
            if($Component_Status){
                Write-Host "Message Center component found!" -ForegroundColor Green
                $Component_Status
            }
            else {
                Write-Host "Message Center component not found." -ForegroundColor Red
            }
            if ($Service_status.Status -eq "Running") {
                Write-Host "Message Center Spooler found [$($Service_status.Status)]" -ForegroundColor Cyan
            }
            else {
                Write-Host "Message Center Spooler Servie found [$($Service_status.Status)]" -ForegroundColor Red
            }
            Write-Host ""
        }
    }
}
Message-Center