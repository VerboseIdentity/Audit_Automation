clear-Host
$currentDirectory = (Get-Location).Path

if (Test-Path -Path .\Web\Config.xml) {
    try {
        $configData = Import-Clixml -Path .\Web\Config.xml

        foreach ($Config_value in $configData) {

            if ($Config_value.Web_LB) {

                $Config_value.Web_LB
            } else {
            
                Write-Host "One or more values are not available. Please complete the setup."
                Start-Sleep -Seconds 1
                .\Web\Create_Web_Config.ps1
                break
            }
        }
    } catch {
       
        Write-Host "Error importing configuration data: $_"
    }
} else {
    Write-Host "Config.xml not found. Please create the configuration file."
    .\Web\Create_Web_Config.ps1
}

function  Main {
    while ($true) {
        Clear-Host
        Write-Host "Choose the options as per the requirement:`n"
        Write-Host "1. Check SSL, OSA, STS and AUP Certificates"
        Write-Host "2. Check Web Server Components and Pre-Requisite Wrapper"
        Write-Host "3. Check ATP Version"
        Write-Host "4. Unity installation check and service account verification"
        Write-Host "5. SSL-Binding Check"
        Write-Host "6. Browse ATP and MERT URLs"
        Write-Host "7. Add Permissions to OSA and STS Certificates"
        Write-Host "8. Check AppPools and TW ScanPool Service account"
        Write-Host "9. Check OSA Status"
        Write-Host "0. Exit`n"

        $choice = Read-Host "Please enter the number "

        switch ($choice) {
            1 {$Certs_verification = Join-Path $currentDirectory "Web\Check_SSL_OSA_STS_Certs.ps1"
        & $Certs_verification}

            2 {$Web_components = Join-Path $currentDirectory ".\Web\Web_components_and_Pre-Req_wrapper.ps1"
        & $Web_components}

            3 {$ATP = Join-Path $currentDirectory ".\Web\ATP_Version_Check.ps1"
        & $ATP}

            4 {$Unity = Join-Path $currentDirectory ".\Web\Unity_installation_Check.ps1"
        & $Unity}

            5 {$SSL = Join-Path $currentDirectory ".\Web\SSL_binding.ps1"
        & $SSL}

            6 {$URLs = Join-Path $currentDirectory ".\Web\Browse_URLs.ps1"
        & $URLs}

            7 {$Cert_Permissions = Join-Path $currentDirectory ".\Web\Add_Cert_permissons.ps1"
        & $Cert_Permissions}

            8 {$Pools = Join-Path $currentDirectory ".\Web\AppPools.ps1"
        & $Pools}

            9 {$OSA = Join-Path $currentDirectory ".\Web\OSA.ps1"
        & $OSA}

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