clear-Host
function Components{
        $Header = "`nChecking Web components and Pre-requisite wrapper components on Web Servers"
        Write-Host "$Header`n$('-' * $Header.Length)" -ForegroundColor DarkYellow
        $Servers = Get-Content -Path .\Servers.txt

        foreach($Server in $Servers){
            if($Server.Split(",")[1] -eq "MSG" -or $Server.Split(",")[1] -eq "PRT" -or $Server.Split(",")[1] -eq "FAX" -or $Server.Split(",")[1] -eq "ACDM"){

                $target = $Server.Split(",")[0]
                $values = Invoke-Command -ComputerName $target -ScriptBlock{

                    Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, Publisher,DisplayVersion | Where {$_.Publisher -like '*Allscripts*' -or $_.Publisher -like '*Clinical*' -or $_.Publisher -like '*Altera*' -or $_.Publisher -like '*Black Ice Software*' -or $_.Publisher -like '*Midmark*'} | Sort-Object DisplayName | Format-Table DisplayName, Publisher,DisplayVersion
            }
            $Server_Prompt = "Searching for the components on [$target]"
            Write-Host $Server_Prompt `n$('.' * $Server_Prompt.Length) -ForegroundColor DarkCyan
            $values
        }
    }

}
Components