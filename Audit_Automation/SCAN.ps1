clear-Host
$currentDirectory = (Get-Location).Path
function  Main {
    while ($true) {
        Clear-Host
        Write-Host "SCAN Server Audit`n*****************"
        Write-Host "1. Check DemoMode and CommandTimeout in Impact.CFG"
        Write-Host "0. Exit`n"

        $choice = Read-Host "Please enter the number "

        switch ($choice) {
            1 {$SCAN_CFG = Join-Path $currentDirectory "SCAN\Impact_CFG_Check.ps1"
        & $SCAN_CFG}

            0 {return}
            Default {Write-Host "Invalid choice.."}
        }
        $returnChoice = Read-Host "Do you want to return to the main screen? [Y/N]"
        if ($returnChoice -ne 'Y'){
        break
        }
    }
}
Main