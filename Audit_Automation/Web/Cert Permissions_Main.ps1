Write-Host "`nAdding Permission to OSA, STS and .000 certs..." -ForegroundColor Yellow

$RSA = "c:\programdata\microsoft\crypto\rsa\machinekeys\"

$userName = 'IIS APPPOOL\CMSV4 POOL,IIS APPPOOL\TWClient Pool,IIS AppPool\TWIdentityServer Pool,Network Service,IUSR'

$userNames = $userName -split (",")

foreach($user in $userNames){

$permission = 'Fullcontrol'

$rule = new-object security.accesscontrol.filesystemaccessrule $user, $permission, allow

$OBJ = New-Object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::My,"Localmachine")

$OBJ.Open("MaxAllowed")

$OSACert = $OBJ.Certificates | Where-Object {$_.Subject -like "*OSA*"}; if (-not $OSACert) {Write-Host "OSA Certificate not found." -ForegroundColor DarkRed}

foreach($eachOSA in $OSACert){

try{

$OSAPathakam = $eachOSA.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName

$OKA = $RSA+$OSAPathakam

$acl =  get-acl -path $OKA

$acl.AddAccessRule($rule)

Set-Acl $OKA $acl -ErrorAction Stop

Write-Host "Permissions applied on OSA Certificate for [$user]" -ForegroundColor Green}
catch{Write-Host "Failed to apply permissions on OSA Certificate for [$user]" -ForegroundColor Red}

}

$STSCert = $OBJ.Certificates | Where-Object {$_.Subject -like "*STS*"}; if (-not $STSCert) {Write-Host "STS Certificate not found." -ForegroundColor DarkRed}

foreach($eachSTS in $STSCert){

try{

$STSPathakam = $eachSTS.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName

$OKA = $RSA+$STSPathakam

$acl =  get-acl -path $OKA

$acl.AddAccessRule($rule)

Set-Acl $OKA $acl -ErrorAction Stop

Write-Host "Permissions applied on STS Certificate for [$user]" -ForegroundColor Green}
catch{Write-Host "Failed to apply permissions on STS Certificate for [$user]" -ForegroundColor Red}

}

$dot000 = $OBJ.Certificates | Where-Object {$_.FriendlyName -like "*.000"}; if (-not $dot000Cert) {Write-Host ".000 Certificate not found." -ForegroundColor DarkRed}

foreach($eachdot000 in $dot000Cert){

try{

$dot000Pathakam = $eachSTS.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName

$OKA = $RSA+$dot000Pathakam

$acl =  get-acl -path $OKA

$acl.AddAccessRule($rule)

Set-Acl $OKA $acl -ErrorAction Stop

Write-Host "Permissions applied on .000 Certificate for [$user]" -ForegroundColor Green}
catch{Write-Host "Failed to apply permissions on .000 Certificate for [$user]" -ForegroundColor Red}
}
}
