Clear-Host
    function E-Coupon{

        $header = "`nE-Coupon verification"
        Write-Host "$header`n$('-'*$header.Length)"
        $Servers = Get-Content -Path '.\Servers.txt'
        foreach($Server in $Servers){
            if ($Server.Split(',')[1] -eq 'DB') {
                $target = $Server.Split(',')[0]
                $Config_details = Import-Clixml -Path '.\Database\Config.xml'
                $Instance = $Config_details.sql_instance
                $Username = $Config_details.sql_Username
                $Password = $Config_details.sql_Password
                $output = Invoke-Command -ComputerName $target -ScriptBlock{
                    Invoke-Sqlcmd -ServerInstance $Using:Instance -Username $Using:Username -Password $Using:Password -Query "Select * from Works..AHSPreference where [Key] = 'EnableECoupon'"
                }
                if ($output.Value -eq 'Y') {
                    Write-Host "E-coupon enabled!" -ForegroundColor DarkGreen
                    $table = $output | Format-Table | Out-String
                    Write-Host $table -ForegroundColor Green
                }
                else {
                    Write-Host "E-Coupon not enabled" -ForegroundColor DarkRed
                    $table = $output | Format-Table | Out-String
                    Write-Host $table -ForegroundColor Red
                }
                break
            }
        }
    }
E-Coupon