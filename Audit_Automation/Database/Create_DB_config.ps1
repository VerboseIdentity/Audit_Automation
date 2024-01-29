function Create-ConfigFile {

    $username = Read-Host "Enter Sql username"
    $securePassword = Read-Host "Enter Sql password" -AsSecureString
    $sql_instance = Read-Host "Enter the SQL instance"

    $password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword))

    $configData = @{
        sql_Username = $username
        sql_Password = $password
        sql_instance = $sql_instance
    }

    $currentDir = (Get-Location).Path
    $xmlFilePath = Join-Path $currentDir "Database\Config.xml"
    $configData | Export-Clixml -Path $xmlFilePath
    Write-Host "Config file created successfully at $xmlFilePath."
}
Create-ConfigFile