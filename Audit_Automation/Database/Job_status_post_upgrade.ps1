Clear-Host

class Queries{
    [string]ATP(){
        $ATP_Query = "/****** Script for SelectTopNRows command from SSMS  ******/
        Declare @jobname varchar (max)
        declare @latestrundate int
        declare @latestruntime int
        declare @fulldatetime datetime
        declare @Upgradedate datetime
        
        select @jobname = A.job_id from [msdb].[dbo].[sysjobs] A  where A.name like '%Term%' 
        select @latestrundate = max(B.run_date) from [msdb].[dbo].[sysjobhistory] B where B.job_id=@jobname and B.step_id=0
        select @latestruntime = max(B.run_time) from [msdb].[dbo].[sysjobhistory] B where B.job_id=@jobname and B.run_date=@latestrundate and B.step_id=0
        select @fulldatetime=  convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8)))
        select @Upgradedate= LastModDTTM from Works..Versionnumber where VersionNumber='11.0.0'
        
        
        SELECT  B.[job_id]
              ,A.name
              ,convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8))) as JobExecutionTime
              ,@Upgradedate as LastUpgradeTime
              ,[run_status]
              ,case when @fulldatetime>@Upgradedate then 'True' else 'False' End as IsValid
          FROM  [msdb].[dbo].[sysjobs] A
          inner join [msdb].[dbo].[sysjobhistory] B on A.job_id=B.job_id
          where B.job_id=@jobname and run_status = 1 and B.step_id=0  and run_date=@latestrundate and run_time=@latestruntime 
          and convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8)))>@Upgradedate"

return $ATP_Query

    }

    [string]CDS_Archive(){
        $CDS_Archive_Query = "/****** Script for SelectTopNRows command from SSMS  ******/
        Declare @jobname varchar (max)
        declare @latestrundate int
        declare @latestruntime int
        declare @fulldatetime datetime
        declare @Upgradedate datetime
        
        select @jobname = A.job_id from [msdb].[dbo].[sysjobs] A  where A.name like '%CDS Archive Aggregator History - Works%' 
        select @latestrundate = max(B.run_date) from [msdb].[dbo].[sysjobhistory] B where B.job_id=@jobname and B.step_id=0
        select @latestruntime = max(B.run_time) from [msdb].[dbo].[sysjobhistory] B where B.job_id=@jobname and B.run_date=@latestrundate and B.step_id=0
        select @fulldatetime=  convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8)))
        select @Upgradedate= LastModDTTM from Works..Versionnumber where VersionNumber='11.0.0'
        
        
        SELECT  B.[job_id]
              ,A.name
              ,convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8))) as JobExecutionTime
              ,@Upgradedate as LastUpgradeTime
              ,[run_status]
              ,case when @fulldatetime>@Upgradedate then 'True' else 'False' End as IsValid
          FROM  [msdb].[dbo].[sysjobs] A
          inner join [msdb].[dbo].[sysjobhistory] B on A.job_id=B.job_id
          where B.job_id=@jobname and run_status = 1 and B.step_id=0  and run_date=@latestrundate and run_time=@latestruntime 
          and convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8)))>@Upgradedate"

return $CDS_Archive_Query

    }

    [string]CDS_Purge(){
        $cds_purge_Query = "/****** Script for SelectTopNRows command from SSMS  ******/
        Declare @jobname varchar (max)
        declare @latestrundate int
        declare @latestruntime int
        declare @fulldatetime datetime
        declare @Upgradedate datetime
        
        select @jobname = A.job_id from [msdb].[dbo].[sysjobs] A  where A.name like '%CDS Purge - Works%' 
        select @latestrundate = max(B.run_date) from [msdb].[dbo].[sysjobhistory] B where B.job_id=@jobname and B.step_id=0
        select @latestruntime = max(B.run_time) from [msdb].[dbo].[sysjobhistory] B where B.job_id=@jobname and B.run_date=@latestrundate and B.step_id=0
        select @fulldatetime=  convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8)))
        select @Upgradedate= LastModDTTM from Works..Versionnumber where VersionNumber='11.0.0'
        
        
        SELECT  B.[job_id]
              ,A.name
              ,convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8))) as JobExecutionTime
              ,@Upgradedate as LastUpgradeTime
              ,[run_status]
              ,case when @fulldatetime>@Upgradedate then 'True' else 'False' End as IsValid
          FROM  [msdb].[dbo].[sysjobs] A
          inner join [msdb].[dbo].[sysjobhistory] B on A.job_id=B.job_id
          where B.job_id=@jobname and run_status = 1 and B.step_id=0  and run_date=@latestrundate and run_time=@latestruntime 
          and convert(datetime,cast(@latestrundate as char(8)) +' '+cast(dateadd(hour,(@latestruntime/10000)%100,dateadd(minute,(@latestruntime/100)%100 ,dateadd(second,(@latestruntime%100),cast('00:00:00'as time(2))))) as char(8)))>@Upgradedate"

return $cds_purge_Query
        
    }

}


$Object = [Queries]::new()

function Jobs-post-upgrade{

    $headers = "`nChecking Term Sync, CDS Archive Aggregator History - Works and CDS Purge job status:"
    Write-Host "$headers`n$('-'*$headers.Length)"

    $configData = Import-Clixml -Path .\Database\Config.xml
    $Username = $configData.Sql_Username
    $password = $configData.Sql_Password
    $instance = $configData.Sql_Instance
    $Servers = Get-content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]
            $Object_ATP = $Object.ATP()
            $ATP_Status = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $using:Username -Password $using:password -Query $using:Object_ATP #| Format-Table | Out-String  
            }
            $Object_CDS = $Object.CDS_Archive()
            $CDS_Archive =  Invoke-Command -ComputerName $target -ScriptBlock {
                Invoke-Sqlcmd -ServerInstance $using:instance -Username $using:Username -Password $using:password -Query $using:Object_CDS
            }
            $Object_Purge = $Object.CDS_Purge()
            $CDS_Purge =  Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $using:instance -Username $using:Username -Password $using:password -Query $using:Object_Purge 
            }
        
            if ([Bool]$ATP_Status.IsValid -eq $true) {
                Write-Host "$($ATP_Status.name) completed successfully post Upgrade"
                Write-Host "----------------------------------------------------------------"
                Write-Host $($ATP_Status | Format-Table | Out-String) -ForegroundColor Green
            }
            else {
                Write-Host "$($ATP_Status.name) did NOT run successfully post Upgrade"
                Write-Host "---------------------------------------------------------------"
                Write-Host $($ATP_Status | Format-Table | Out-String) -ForegroundColor Red
            }
        
            if ([Bool]$CDS_Archive.IsValid -eq $true) {
                Write-Host "$($CDS_Archive.name) completed successfully post Upgrade"
                Write-Host "--------------------------------------------------------------------------"
                Write-Host $($CDS_Archive | Format-Table | Out-String) -ForegroundColor Green
            }
            else {
                Write-Host "$($CDS_Archive.name) did NOT run successfully post Upgrade"
                Write-Host "-------------------------------------------------------------------------"
                Write-Host $($CDS_Archive | Format-Table | Out-String) -ForegroundColor Red
            }
        
            if ([Bool]$CDS_Archive.IsValid -eq $true) {
                Write-Host "$($CDS_Purge.name) completed successfully post Upgrade"
                Write-Host "------------------------------------------------------"
                Write-Host $($CDS_Purge | Format-Table | Out-String) -ForegroundColor Green
            }
            else {
                Write-Host "$($CDS_Purge.name) did NOT run successfully post Upgrade"
                Write-Host "--------------------------------------------------------"
                Write-Host $($CDS_Purge | Format-Table | Out-String) -ForegroundColor Red
            }
        }
        break
    }
}
Jobs-post-upgrade