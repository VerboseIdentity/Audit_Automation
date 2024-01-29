clear-Host
$currentDirectory = (Get-Location).Path

if (Test-Path -Path .\Database\Config.xml) {
    try {
        $configData = Import-Clixml -Path .\Database\Config.xml

        foreach ($Config_value in $configData) {

            if ($Config_value.Sql_Username -and $Config_value.Sql_Password -and $Config_value.Sql_Instance) {
               
                $Config_value.Sql_Username
                $Config_value.Sql_Password
                $Config_value.Sql_Instance
            } else {
              
                Write-Host "One or more values are not available. Please complete the setup."
                Start-Sleep -Seconds 1
                .\Database\Create_DB_config.ps1
                break
            }
        }
    } catch {
       
        Write-Host "Error importing configuration data: $_"
    }
} else {
    Write-Host "Config.xml not found. Please create the configuration file."
    .\Database\Create_DB_config.ps1
}

write-Host "Installing SQLServer module..."
Install-Module -Name SQLServer -Force -AllowClobber


function  Main {
    while ($true) {
        Clear-Host
        Write-Host "Choose the options as per the requirement:`n"
        Write-Host "1. Database Version Check"
        Write-Host "2. ATP DB Version Check"
        Write-Host "3. Careguides and Noteforms Check"
        Write-Host "4. Old CED Jobs Check"
        Write-Host "5. Pre-Requsite Wapper Check"
        Write-Host "6. Get-Recommendations-Works job check"
        Write-Host "7. SCAN Integration Verification"
        Write-Host "8. Ad-Hoc-Workloads Optimization verification"
        Write-Host "9. Check AutoStats on indexes in WIP Table"
        Write-Host "10. Check Index-Optimization-Patch Status"
        Write-Host "11. Check Auto-Shrink Status"
        Write-Host "12. Check Max Degree of Parallelism (MAXDOP)"
        Write-Host "13. Check Cost Threshold for Parallelism"
        Write-Host "14. Term-Sync, CDS Archive History and CDS Purge jobs status post upgrade"
        Write-Host "15. Exit`n"

        $choice = Read-Host "Please enter the number "

        switch ($choice) {
            1 {$databaseVersionCheck_path = Join-Path $currentDirectory "Database\Database_Version_Check.ps1"
        & $databaseVersionCheck_path}

            2 {$ATP_Version_check = Join-Path $currentDirectory "Database\ATP_Version_check.ps1"
        & $ATP_Version_check}

            3 {$Careguides_Noteforms_check = Join-Path $currentDirectory "Database\Careguides_and_noteforms_Check.ps1"
        & $Careguides_Noteforms_check}

            4 {$CED_Jobs = Join-Path $currentDirectory "Database\Old_CED_Jobs.ps1"
        & $CED_Jobs}

            5 {$Pre_req = Join-Path $currentDirectory "Database\Pre_Requsite_wrapper_Check.ps1"
        & $Pre_req}

            6 {$Get_Recommendations = Join-Path $currentDirectory "Database\Get_recommendations_Job_Check.ps1"
        & $Get_Recommendations}

            7 {$Scan_integr = Join-Path $currentDirectory "Database\Scan_Integration_Check.ps1"
        & $Scan_integr}

            8 {$Ad_hoc = Join-Path $currentDirectory "Database\Ad_Hoc_Workloads.ps1"
        & $Ad_hoc}

            9 {$WIP = Join-Path $currentDirectory "Database\WIP_Settings.ps1"
        & $WIP}

            10 {$Index_Optimization = Join-Path $currentDirectory "Database\Index_Optimization_Patch.ps1"
        & $Index_Optimization}

            11 {$Auto_Shrink = Join-Path $currentDirectory "Database\Check_AutoShrink.ps1"
        & $Auto_Shrink}

            12 {$MAXDOP = Join-Path $currentDirectory "Database\MAXDOP.ps1"
        & $MAXDOP}

            13 {$Cost_Treshold = Join-Path $currentDirectory "Database\Cost Threshold for Parallelism.ps1"
        & $Cost_Treshold}

            14 {$Job_status_post_upgrade = Join-Path $currentDirectory "Database\Job_status_post_upgrade.ps1"
        & $Job_status_post_upgrade}

            15 {return}
            Default {Write-Host "Invalid choice.."}
        }
        $returnChoice = Read-Host "Do you want to return to the main screen? [Y/N]"
        if ($returnChoice -ne 'Y'){
        break
        }
    }
    
}
Main