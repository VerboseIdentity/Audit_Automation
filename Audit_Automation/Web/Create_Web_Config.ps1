function Create-Web-ConfigFile {

    $Web_LB = Read-Host "Enter the Web Loadbalancer"

    $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

    $configData = @{

        Web_LB = $Web_LB
    }

    $currentDir = (Get-Location).Path
    $xmlFilePath = Join-Path $currentDir "Web\Config.xml"
    $configData | Export-Clixml -Path $xmlFilePath
    Write-Host "Config file created successfully at $xmlFilePath."
}
Create-Web-ConfigFile