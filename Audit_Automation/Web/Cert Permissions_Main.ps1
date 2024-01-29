
Write-Host "`nAdding Permission to OSA and STS certs..." -ForegroundColor Yellow

$RSA = "c:\programdata\microsoft\crypto\rsa\machinekeys\"

$userName = 'IIS APPPOOL\CMSV4 POOL,IIS APPPOOL\TWClient Pool,IIS AppPool\TWIdentityServer Pool,Network Service,IUSR'

$userNames = $userName -split (",")

foreach($user in $userNames){

$permission = 'Fullcontrol'

$rule = new-object security.accesscontrol.filesystemaccessrule $user, $permission, allow

$OBJ = New-Object System.Security.Cryptography.X509Certificates.X509Store([System.Security.Cryptography.X509Certificates.StoreName]::My,"Localmachine")

$OBJ.Open("MaxAllowed")

$OSACert = $OBJ.Certificates | Where-Object {$_.Subject -like "*OSA*"}

foreach($eachOSA in $OSACert){

$OSAPathakam = $eachOSA.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName

$OKA = $RSA+$OSAPathakam

$acl =  get-acl -path $OKA

$acl.AddAccessRule($rule)

echo $OKA

Set-Acl $OKA $acl
}

$STSCert = $OBJ.Certificates | Where-Object {$_.Subject -like "*STS*"}

foreach($eachSTS in $STSCert){

$STSPathakam = $eachSTS.PrivateKey.CspKeyContainerInfo.UniqueKeyContainerName

$OKA = $RSA+$STSPathakam

$acl =  get-acl -path $OKA

$acl.AddAccessRule($rule)

echo $OKA

Set-Acl $OKA $acl

}
}
