Clear-Host
function PML-Drivers{
    $title = "`nChecking PML driver HPZ12 and Net driver HPZ12..."
    Write-Host "$title`n$('-' * $title.Length)" -ForegroundColor Yellow
    $Servers = Get-Content -Path '.\Servers.txt'
    foreach($Server in $Servers){
        if ($Server.split(',')[1] -eq 'MSG' -or $Server.split(',')[1] -eq 'PRT') {
            $target = $Server.split(',')[0]
            $headers = "verifying on [$target]"
            Write-Host "$headers`n$('-' * $headers.Length)" -ForegroundColor Magenta
            $PML = Get-Service -ComputerName $target -DisplayName 'Pml Driver HPZ12*' -ErrorAction SilentlyContinue
            $Netdriver = Get-Service -ComputerName $target -DisplayName 'Net driver HPZ12*' -ErrorAction SilentlyContinue
            if ($PML -ne $null -and $PML.status -eq 'Running'){
                $status = $PML.status
                $Name = $PML.DisplayName
                Write-Host "`n[$Name] found [$status] on $target" -ForegroundColor Red
            }
            elseif ($PML -ne $null -and $PML.status -ne 'Running') {
                $status = $PML.status
                $Name = $PML.DisplayName
                Write-Host "`n[$Name] found [$status] on $target" -ForegroundColor Yellow
            }
            else {
                Write-Host "`nPML driver HPZ12 not found" -ForegroundColor Gray
            }

            if ($Netdriver -ne $null -and $Netdriver.status -eq 'Running'){
                $status = $Netdriver.status
                $Name = $Netdriver.DisplayName
                Write-Host "`n[$Name] found [$status] on $target" -ForegroundColor Red
            }
            elseif ($Netdriver -ne $null -and $Netdriver.status -ne 'Running') {
                $status = $Netdriver.status
                Write-Host "`n[$Name] found [$status] on $target" -ForegroundColor Yellow
            }
            else {
                Write-Host "Net driver HPZ12 not found" -ForegroundColor Gray
            }
            Write-Host ""
        }
    }
}
PML-Drivers