Clear-Host

Write-Host "`nPreparing for adding permissions on remote servers for OSA and STS cers.."

$Servers = Get-Content -Path ".\Servers.txt"

$location = "C:\AHSINSTALL\TW\Misc"

Foreach ($Server in $Servers){

if($Server.split(",")[1] -eq "WEB" -or $Server.split(",")[1] -eq "MSG"){

    $target = $Server.split(",")[0]

    If(Test-Path -Path "\\$target\C$\AHSINSTALL\TW\Misc"){

    Remove-Item -Path "\\$target\C$\AHSINSTALL\TW\Misc\Cert Permissions_Main.ps1" -ErrorAction SilentlyContinue

    Copy-Item -Path ".\Web\Cert Permissions_Main.ps1" -Destination "\\$target\C$\AHSINSTALL\TW\Misc"

    Write-Host "`nPreliminaries set."

    }
    else{

    New-Item -Path "\\$target\C$\AHSINSTALL\TW" -Name Misc -ItemType Directory

    Copy-Item -Path ".\Web\Cert Permissions_Main.ps1" -Destination "\\$target\C$\AHSINSTALL\TW\Misc"

    }

    Invoke-Command -ComputerName $target -ScriptBlock {Set-Location $using:location

    &.\"Cert Permissions_Main.ps1"}

    Write-Host "`nPermissions added on $target" -ForegroundColor Green

    }
    else{continue}
    Write-Host ""
}
