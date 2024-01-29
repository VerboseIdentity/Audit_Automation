Clear-Host
function Pre_req_check{

    Write-Host "`nChecking for Pre-req wrapper..`n******************************"
    
    $Servers = Get-content -Path ".\Servers.txt"

    foreach ($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB"){

            $target = $Server.split(",")[0]
            $output = Invoke-Command -ComputerName $target -ScriptBlock {Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object DisplayName -Like "*Allscripts TouchWorks Prerequisite Wrapper*" | Select-Object DisplayName, Publisher,DisplayVersion | Sort-Object DisplayName | Format-Table DisplayName, Publisher,DisplayVersion}
    
            if ($output){
                Write-Host "Pre-Req Wrapper available on",$target -ForegroundColor Green
                $output
            }
            else {
                Write-Host "Pre-Req Wrapper not available on",$target -ForegroundColor Red
            }
        }

    }

}

Pre_req_check