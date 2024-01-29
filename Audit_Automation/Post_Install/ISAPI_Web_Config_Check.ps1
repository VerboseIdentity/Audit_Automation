Clear-Host
function ISAPI-URL-Check{
     $ISAPIWebConfigFilePath = "C:\inetpub\wwwroot\ISAPI\web.config"

     $hieCDSUrlP = "https://cdsconsole.mucc.allscriptscloud.com/start.aspx"
     $ClientIServerUrlP = "https://CDSEngine.MUCC.AllscriptsCloud.com/ServerService.svc"
     $ClientIServerDNSValueP = "CDSEngine.MUCC.AllscriptsCloud.com"
     $DXCClientIServerUrlP = "https://PLSEngine.MUCC.AllscriptsCloud.com/ServerServiceDXC.svc"
     $DXCClientIServerDNSValueP = "dxcconsole.MUCC.AllscriptsCloud.com"

     $hieCDSUrlT = "https://cdsconsoleuat.mucc.allscriptscloud.com/start.aspx"
     $ClientIServerUrlT = "https://CDSEngineUAT.MUCC.AllscriptsCloud.com/ServerService.svc"
     $ClientIServerDNSValueT = "CDSEngineUAT.MUCC.AllscriptsCloud.com"
     $DXCClientIServerUrlT = "https://PLSEngineUAT.MUCC.AllscriptsCloud.com/ServerServiceDXC.svc"
     $DXCClientIServerDNSValueT = "DXCConsoleuat.mucc.allscriptscloud.com"

     $Environment = Read-Host "If this is a PROD environment please type [P]`nIf ths is Test Environment please type [T]`nInput"
     if ($Environment -notin @('P','T')) {
          Write-Host "Invalid Input..`nTerminating the process..." -ForegroundColor Red
          Start-Sleep -Seconds 2
          exit
     }
     $Servers = Get-Content -Path ".\Servers.txt"
     foreach($Server in $Servers){
          if ($Server.split(",")[1] -eq 'WEB' -or $Server.split(",")[1] -eq 'MSG') {
               $target = $Server.split(",")[0]
               $prompt = "Checking URLs on [$target]"
               Write-Host "$prompt`n$('-'*$prompt.Length)"
               Invoke-Command -ComputerName $target -ScriptBlock{

                    $ISAPIConfig = New-Object System.Xml.XmlDocument
                    $ISAPIConfig.PreserveWhitespace = $true
                    $ISAPIConfig.Load($using:ISAPIWebConfigFilePath)

                    $CDS = $ISAPIConfig | Select-XML –Xpath "//*[@name='CDS']"
                    $Remote_Server_Client_IServer_Secure = $ISAPIConfig | Select-XML –Xpath "//*[@name='Remote_Server_Client_IServer_Secure']"
                    $Remote_Server_DXC_Client_IServer_Secure = $ISAPIConfig | Select-XML –Xpath "//*[@name='Remote_Server_DXC_Client_IServer_Secure']"

                    $hieCDSUrl = $CDS.Node.uri
                    $ClientIServerUrl = $Remote_Server_Client_IServer_Secure.Node.address
                    $ClientIServerDNSValue = $Remote_Server_Client_IServer_Secure.Node.identity.dns.value
                    $DXCClientIServerUrl = $Remote_Server_DXC_Client_IServer_Secure.Node.address
                    $DXCClientIServerDNSValue = $Remote_Server_DXC_Client_IServer_Secure.Node.identity.dns.value

                    if ($Using:Environment -eq 'P') {
                         if ($CDS -ne $null) {

                              if ($hieCDSUrl -eq $Using:hieCDSUrlP) {
                                   Write-Host "`n<hie name=`"CDS`" uri Url is CORRECT" -ForegroundColor DarkGreen
                                   Write-Host "$hieCDSUrl" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<hie name=`"CDS`" uri Url is IN-CORRECT.." -ForegroundColor DarkRed
                                   Write-Host "$hieCDSUrl" -ForegroundColor Red
                              }    
                         }
                         else {
                              Write-Host "`nElement <hie name=`"CDS`" does not exits.." -ForegroundColor Red
                         }
                         if($Remote_Server_Client_IServer_Secure -ne $null){
                              if($ClientIServerUrl -eq $using:ClientIServerUrlP){
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" address Url is CORRECT" -ForegroundColor DarkGreen
                                   Write-Host "$ClientIServerUrl" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" address Url is IN-CORRECT.." -ForegroundColor DarkRed
                                   Write-Host "$ClientIServerUrl" -ForegroundColor Red
                              }

                              if($ClientIServerDNSValue -eq $using:ClientIServerDNSValueP){
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" dns value is CORRECT" -ForegroundColor DarkGreen
                                   Write-Host "dns value=`"$ClientIServerDNSValue`"" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" dns value is IN-CORRECT....." -ForegroundColor DarkRed
                                   Write-Host "$ClientIServerDNSValue" -ForegroundColor Red
                              }
                         }
                         else {
                              Write-Host "`nElement <endpoint name=`"Remote_Server_Client_IServer_Secure`" does not exits....." -ForegroundColor Red
                         }

                         if($Remote_Server_DXC_Client_IServer_Secure -ne $null){
                              if($DXCClientIServerUrl -eq $using:DXCClientIServerUrlP){
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" address Url is CORRECT" -ForegroundColor DarkGreen
                                   Write-Host "$DXCClientIServerUrl" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" address Url is IN-CORRECT.." -ForegroundColor DarkRed
                                   Write-Host "$DXCClientIServerUrl" -ForegroundColor Red
                              }

                              if($DXCClientIServerDNSValue -eq $using:DXCClientIServerDNSValueP){
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" dns value is CORRECT" -ForegroundColor DarkGreen
                                   Write-Host "$DXCClientIServerDNSValue" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" dns value is IN-CORRECT.." -ForegroundColor DarkRed
                                   Write-Host "$DXCClientIServerDNSValue" -ForegroundColor Red
                              }
                         }
                         else {
                              Write-Host "`nElement <endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" does not exits.." -ForegroundColor Red
                         }
                         Write-Host ""
                    }
                    elseif($Using:Environment -eq 'T') {
                         if($CDS -ne $null){
                              if($hieCDSUrl -eq $using:hieCDSUrlT){
                                   Write-Host "`n<hie name=`"CDS`" uri Url is CORRECT, no need to update. Skipping.." -ForegroundColor DarkGreen
                                   Write-Host "$hieCDSUrl" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<hie name=`"CDS`" uri Url is IN-CORRECT..." -ForegroundColor DarkRed
                                   Write-Host "$hieCDSUrl" -ForegroundColor Red
                              }
                         }
                         else {
                              Write-Host "`nElement <hie name=`"CDS`" does not exits..." -ForegroundColor Red
                         }
                         
                         if($Remote_Server_Client_IServer_Secure -ne $null){
                              if($ClientIServerUrl -eq $using:ClientIServerUrlT){
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" address Url is CORRECT..." -ForegroundColor DarkGreen
                                   Write-Host "$ClientIServerUrl" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" address Url is IN-CORRECT..." -ForegroundColor DarkRed
                                   Write-Host "$ClientIServerUrl" -ForegroundColor Red
                              }

                              if($ClientIServerDNSValue -eq $using:ClientIServerDNSValueT){
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" dns value is CORRECT.." -ForegroundColor DarkGreen
                                   Write-Host "$ClientIServerDNSValue" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_Client_IServer_Secure`" dns value is IN-CORRECT..." -ForegroundColor DarkRed
                                   Write-Host "$ClientIServerDNSValue" -ForegroundColor Red
                              }
                         }
                         else {
                              Write-Host "`nElement <endpoint name=`"Remote_Server_Client_IServer_Secure`" does not exits....." -ForegroundColor Red
                         }

                         if($Remote_Server_DXC_Client_IServer_Secure -ne $null){
                              if($DXCClientIServerUrl -eq $using:DXCClientIServerUrlT){
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" address Url is CORRECT" -ForegroundColor DarkGreen
                                   Write-Host "$DXCClientIServerUrl" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" address Url is IN-CORRECT.." -ForegroundColor DarkRed
                                   Write-Host "$DXCClientIServerUrl" -ForegroundColor Red
                              }

                              if($DXCClientIServerDNSValue -eq $using:DXCClientIServerDNSValueT){
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" dns value is CORRECT" -ForegroundColor DarkGreen
                                   Write-Host "$DXCClientIServerDNSValue" -ForegroundColor Green
                              }
                              else {
                                   Write-Host "`n<endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" dns value is IN-CORRECT..." -ForegroundColor DarkRed
                                   Write-Host "$DXCClientIServerDNSValue" -ForegroundColor Red
                              }
                         }
                         else {
                              Write-Host "`nElement <endpoint name=`"Remote_Server_DXC_Client_IServer_Secure`" does not exits.." -ForegroundColor Red
                         }
                         Write-Host ""
                    }
                    else {
                         Write-Host "Invalide Option." -ForegroundColor Red
                    }
               }
          }
     }
}
ISAPI-URL-Check