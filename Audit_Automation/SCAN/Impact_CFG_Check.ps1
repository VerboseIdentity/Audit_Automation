Clear-Host

function Impact-CFG{

    $Servers = Get-Content -Path ".\Servers.txt"
    $header = "Searching for DemoMode."
    Write-Host "$header`n$('-'*$header.Length)"
    foreach($Server in $Servers){
        if($Server.split(",")[1] -eq 'SCAN'){
            $target = $Server.split(",")[0]
            $Impact_file = Invoke-command -ComputerName $target -ScriptBlock {
                Get-Content -Path "C:\Program Files (x86)\Allscripts\TouchChart\Server\IMPACT.CFG"
            }
            foreach($each_line in $Impact_file){
                if('DemoMode=False' -in $each_line){
                    $each_line
                    $DemoMode = 'False'
                    break
                }
            }
        }
    }
    if ($DemoMode) {
        Write-Host "DemoMode is set to False" -ForegroundColor Green
    }
    else {
        Write-Host "DemoMode is NOT set to False" -ForegroundColor Red
    }
    Write-Host ""
    $header1 = "Searching for CommandTimeout."
    Write-Host "$header1`n$('-'*$header1.Length)"
    foreach($each_line in $Impact_file){
        if ("CommandTimeout=3600" -in $each_line) {
            $CommandTimeout = 'True'
            $each_line
            break
        }
    }
    if ($CommandTimeout) {
        Write-Host "CommandTimeout is set to 3600" -ForegroundColor Green
    }
    else {
        Write-Host "CommandTimeout is NOT set to 3600" -ForegroundColor Red
    }
    Write-Host ""
}
Impact-CFG