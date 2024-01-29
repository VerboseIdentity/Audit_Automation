Clear-Host

function ATP-Web {
    $Header = "`nChecking ATP Version on Web Servers"
    Write-Host "$Header`n$('-' * $Header.Length)" -ForegroundColor DarkYellow
    $Servers = Get-Content -Path .\Servers.txt
    $Base = 2.0.2.47
    foreach ($Server in $Servers) {
        if ($Server.Split(",")[1] -eq "WEB") {
            $target = $Server.Split(",")[0]
            $values = Invoke-Command -ComputerName $target -ScriptBlock {
                Get-ItemProperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' |
                Select-Object DisplayName, Publisher, DisplayVersion |
                Where-Object { $_.Publisher -like '*Clinical Architecture LLC*' } |
                Sort-Object DisplayName
            }

            $Server_Prompt = "Searching for ATP components on [$target]"
            Write-Host $Server_Prompt `n$('.' * $Server_Prompt.Length) -ForegroundColor Cyan

            foreach ($item in $values) {
                $latestStatus = if ([Version]$item.DisplayVersion -ge [Version]$Base) { 'Latest' } else { 'Outdated' }
                $statusColor = if ($latestStatus -eq 'Latest') { 'Green' } else { 'Red' }

                $object = [PSCustomObject]@{
                    DisplayName     = $item.DisplayName
                    Publisher       = $item.Publisher
                    DisplayVersion  = $item.DisplayVersion
                    Status          = $latestStatus
                }

                $formattedObject = $object | Format-Table -AutoSize | Out-String
                if ($latestStatus -eq 'Latest') {
                    Write-Host $formattedObject -ForegroundColor Green
                } else {
                    Write-Host $formattedObject -ForegroundColor Red
                }
            }
        }
    }
}

ATP-Web
