clear-Host
$currentDirectory = (Get-Location).Path
function  Main {
    while ($true) {
        Clear-Host
        Write-Host "Post Install Audit`n******************"
        Write-Host "1. ISAPI Web Config URLs Check"
        Write-Host "2. Check the Services Status"
        Write-Host "3. Check Re-Indexer Status"
        Write-Host "4. Check MERT-Sync Job Status"
        Write-Host "5. E-Coupon verification"
        Write-Host "6. PML driver HPZ12 and Net driver HPZ12 Status Verification"
        Write-Host "0. Exit`n"

        $choice = Read-Host "Please enter the number "

        switch ($choice) {
            1 {$ISAPI = Join-Path $currentDirectory "Post_Install\ISAPI_Web_Config_Check.ps1"
        & $ISAPI}

            2 {$Services = Join-Path $currentDirectory "Post_Install\Services_status.ps1"
        & $Services}

            3 {$Re_Indexer = Join-Path $currentDirectory "Post_Install\Re-Indexer.ps1"
        & $RE_indexer}

            4 {$MERT = Join-Path $currentDirectory "Post_Install\MERT_Sync.ps1"
        & $MERT}

            5 {$Coupons = Join-Path $currentDirectory "Post_Install\E-Coupon_Verification.ps1"
        & $Coupons}

            6 {$Drivers = Join-Path $currentDirectory "Post_Install\PML drivers.ps1"
        & $Drivers}

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