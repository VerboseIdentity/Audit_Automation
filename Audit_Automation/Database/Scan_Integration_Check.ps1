Clear-Host
function Scan_integration_check {
    Write-Host "`nChecking Scan Integration Version...`n------------------------------------"
    $Servers = Get-Content -Path ".\Servers.txt"
    $Base = 22.10.388
    
    foreach($Server in $Servers){

        if($Server.Split(",")[1] -eq "DB"){
            $target = $Server.Split(",")[0]
            $Scan_integration = Invoke-Command -ComputerName $target -ScriptBlock{Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object DisplayName -Like "*Allscripts TouchWorks Scan Integration*" |Select-Object DisplayName, Publisher,DisplayVersion | Sort-Object DisplayName | Format-Table DisplayName, Publisher,DisplayVersion}
            $Scan_Version = Invoke-Command -ComputerName $target -ScriptBlock{Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Where-Object DisplayName -like "*Allscripts TouchWorks Scan Integration*" | Select-Object -ExpandProperty DisplayVersion}
            
            if ([Version]$Scan_Version -ge [Version]$Base) {
                Write-Host "Scan Integration is on latest version on",$Server.Split(",")[0] -ForegroundColor Green
                $Scan_integration
            }
            else {
                Write-Host "Scan Integration is not on the latest version on",$Server.Split(",")[0] -ForegroundColor Red
                $Scan_integration
            }
        }
    }
}
Scan_integration_check