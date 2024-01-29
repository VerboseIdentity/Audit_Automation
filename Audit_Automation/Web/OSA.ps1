
clear-Host

$Servers = Get-Content -Path ".\Servers.txt"
function OSA-Check{
    $header = "Checking OSA status.."
    Write-Host "$header`n$('.'*$header.Length)"
    foreach($Server in $Servers){
        if($Server.Split(',')[1] -eq "WEB"){
            $target = $Server.Split(',')[0]
            $OSA_App = Invoke-Command -ComputerName $target -ScriptBlock{ Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher,DisplayVersion | Where {$_.Publisher -like '*Allscripts Healthcare Solutions, Inc.*'} | Sort-Object DisplayName | Format-Table DisplayName, Publisher,DisplayVersion}
        
            if ($OSA_App) {
                Write-Host "`nOSA Installed on [$target]" -ForegroundColor Green
                $OSA_App
                Write-Host ""
            }
            else {
                Write-Host "`nOSA is NOT installed on [$target]`n" -ForegroundColor Red
            }
        }
    }
}

function OSA-URL{

    foreach($Server in $Servers){
        if ($Server.Split(",")[1] -eq "WEB") {
            $config_data = Import-Clixml -Path ".\Web\Config.xml"
            $LB = $config_data.Web_LB
            $URL = "https://" + $LB + "/SecurityAgentService/api/diagnostic"
            $Response = Invoke-WebRequest -Uri $URL -UseBasicParsing
        
            if($Response.StatusCode -eq 200){
            Write-Host "OSA Dignostic URL launched successfully without any errors" -ForegroundColor Cyan}
            else{
            Write-Host "OSA Dignostic URL FAILED to launch" -ForegroundColor Red}       
            break
        }
    }
}
OSA-Check
OSA-URL
