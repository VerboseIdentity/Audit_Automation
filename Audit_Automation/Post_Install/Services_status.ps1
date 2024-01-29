Clear-Host
function Services-status{

    $header = "Checking Service status."
    Write-Host "$header`n$('-'*$header.Length)"
    $Servers = Get-Content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -ne "DB") {
            $Services = @(
    '*W3SVC*', '*IISADMIN*', '*DeltaService*', '*XtendDataService*',
    '*MDRXRestoration*', '*AllscriptsLoggingAgentService*', '*TWMessageCenterSpooler*',
    '*TWFaxJobStatusUpdateService*', '*TWPrintFaxQueueMonitor*', '*EEHRProcessMonitor*',
    '*Allscripts Community Gateway Adapter*', '*SymedicalServerBackGroundProcessor*',
    '*SymedicalServerDistribution*', '*AllscriptsNNClient*', '*MERTDistributionClient*',
    '*SCRTBackgroundProcessing*', '*Allscripts.IHE.GatewayAdapter*',
    '*AllscriptsUnityLogService*', '*IMPACT_IEX*', '*IMPACT_TIFFER*'
        )
        
            $target = $Server.split(",")[0]
            $header = "Services Status on [$target]"
            $underline = '-' * $header.Length
            Write-Host "$header`n$underline" -ForegroundColor DarkMagenta
            $Res = Invoke-Command -ComputerName $target -ScriptBlock {
                $ResultArray = foreach ($Service in $Using:Services) {
                    $ServiceInfo = Get-Service -Name $Service | Select-Object DisplayName, Status, StartType
                    if ($ServiceInfo) {
                        $ServiceInfo
                    }
                }
            
                $ResultArray
            }
            
            $Res | Select-Object DisplayName, Status, StartType | Format-Table -AutoSize
            
        }
    }
}
Services-status