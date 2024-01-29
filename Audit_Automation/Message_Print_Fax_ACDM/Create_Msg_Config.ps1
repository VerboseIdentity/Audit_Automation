function Create-Web-ConfigFile {

    $Web_LB = Read-Host "Enter the Web Loadbalancer"

    $configData = @{

        Web_LB = $Web_LB
    }

    $currentDir = (Get-Location).Path
    $xmlFilePath = Join-Path $currentDir "Message_Print_Fax_ACDM\Config.xml"
    $configData | Export-Clixml -Path $xmlFilePath
    Write-Host "Config file created successfully at $xmlFilePath."
}
Create-Web-ConfigFile