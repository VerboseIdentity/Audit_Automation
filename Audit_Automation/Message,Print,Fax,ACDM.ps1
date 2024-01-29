clear-Host
$currentDirectory = (Get-Location).Path

if (Test-Path -Path .\Message_Print_Fax_ACDM\Config.xml) {
    try {
        $configData = Import-Clixml -Path ".\Message_Print_Fax_ACDM\Config.xml"

        foreach ($Config_value in $configData) {

            if ($Config_value.Web_LB) {

                $Config_value.Web_LB
            } else {
            
                Write-Host "One or more values are not available. Please complete the setup."
                Start-Sleep -Seconds 1
                .\Message_Print_Fax_ACDM\Create_Msg_Config.ps1
                break
            }
        }
    } catch {
       
        Write-Host "Error importing configuration data: $_"
    }
} else {
    Write-Host "Config.xml not found. Please create the configuration file."
    .\Message_Print_Fax_ACDM\Create_Msg_Config.ps1
}

function  Main {
    while ($true) {
        Clear-Host
        Write-Host "Message and etc Server Audit`n*********************************"
        Write-Host "1. SSL, OSA, STS, AUP Certificates check"
        Write-Host "2. Check Message Center Components and Service Status"
        Write-Host "3. SSL Binding Check"
        Write-Host "4. Required TW components Check"
        Write-Host "5. Print and Fax Services Check"
        Write-Host "6. ATP Version Check"
        Write-Host "7. Default Printer Verification"
        Write-Host "0. Exit`n"

        $choice = Read-Host "Please enter the number "

        switch ($choice) {
            1 {$Cert_thumbprints = Join-Path $currentDirectory "Message_Print_Fax_ACDM\SSL_OSA_STS_AUP_Certs.ps1"
        & $Cert_thumbprints}
            
            2 {$Message_Center_Checks = Join-Path $currentDirectory "Message_Print_Fax_ACDM\Message_Center_Checks.ps1"
        & $Message_Center_Checks}

            3 {$SSL = Join-Path $currentDirectory "Message_Print_Fax_ACDM\SSL-Check.ps1"
        & $SSL}

            4 {$Components = Join-Path $currentDirectory "Message_Print_Fax_ACDM\Components_check.ps1"
        & $Components}

            5 {$Service = Join-Path $currentDirectory "Message_Print_Fax_ACDM\Service_Checks.ps1"
        & $Service}

            6 {$ATP = Join-Path $currentDirectory "Message_Print_Fax_ACDM\ATP_Version_Check.ps1"
        & $ATP}

            7 {$Printer = Join-Path $currentDirectory "Message_Print_Fax_ACDM\Default-Printer.ps1"
        & $Printer}

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