Clear-Host

function URL-Maker{

    param($ATP,$MERT)

    $config_details = Import-Clixml -Path ".\Web\Config.xml"
    $LB = $config_details.Web_LB
    $ATP_URL = "https://" + $LB + $ATP
    $MERT_URL = "https://" + $LB + $MERT

    return $ATP_URL, $MERT_URL
}
function Connector {
    param ($URL)
    $Servers = Get-Content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if($Server.split(",")[1] -eq "WEB"){
            $target = $Server.split(",")[0]
            Invoke-Command -ComputerName $target -ScriptBlock{
                $result = Invoke-WebRequest -Uri $using:URL -UseBasicParsing
                return $result
            }
            break
        }
    }
}

$ATP_URL, $MERT_URL = URL-Maker -ATP "/SymedicalRuntimeServices/TerminologyService.asmx" -MERT "/MERT/"

$ATP_Connection = Connector -URL $ATP_URL
$MERT_Connection = Connector -URL $MERT_URL

$headers = "`nBrowsing ATP and MERT URLs"
Write-Host "$headers`n$('-'*$headers.Length)"

if ($ATP_Connection.StatusCode -eq 200){
    Write-Host "Successfully browsed the ATP URL without any errors." -ForegroundColor Green
}
else {
    Write-Host "Unable to browse the ATP URL without error" -ForegroundColor Red
}

if ($MERT_Connection.StatusCode -eq 200){
    Write-Host "Successfully browsed the MERT URL without any errors." -ForegroundColor Green
}
else {
    Write-Host "Unable to browse the MERT URL without error" -ForegroundColor Red
}
Write-Host ""