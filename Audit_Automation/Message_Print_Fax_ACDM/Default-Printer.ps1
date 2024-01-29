Clear-Host

function Def-Printer {
    $header = "Checking the Default Printer"
    Write-Host "$header`n$('*'*$header.Length)"
    $Servers = Get-Content -Path .\Servers.txt
    $creds = Get-Credential -Message "Account on which spooler runs: " -UserName "SpoolerAccount"
    foreach($Server in $Servers){
        if ($Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX") {
            $target = $Server.Split(",")[0]
            $Defprt = Invoke-Command -ComputerName $target -Credential $creds -ScriptBlock {(Get-ItemProperty "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows").Device}
            $prompt = "Server : $target"
            $space = " "*10
            [PSCustomObject] @{Server = $target + $space ; Printer = $Defprt.Split(",")[0] + $space * 2}
        }
    }
}
Write-Host ""
Def-Printer