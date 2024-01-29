Clear-Host

$Query = "/****** Script for SelectTopNRows command from SSMS  ******/
Declare @jobname varchar (max)
declare @latestrundate int
declare @latestruntime int
declare @fulldatetime datetime
declare @Upgradedate datetime

select @jobname = A.job_id from [msdb].[dbo].[sysjobs] A  where A.name like '%Allscripts Intelligent re-indexer%' 
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

  function Re-Indexer-Check{
    $Servers = Get-Content -Path ".\Servers.txt"
    $header = "Checking Re-Indexer Status"
    Write-Host "$header`n$('*'*$header.Length)"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $Config_data = Import-Clixml -Path ".\Database\Config.xml"
            $Username = $Config_data.sql_Username
            $Password = $Config_data.sql_Password
            $Instance = $Config_data.sql_instance
            $target = $Server.split(",")[0]
            $Output = Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Instance -Query $Using:Query
            }
            if ($Output.IsValid -eq 'True') {
                Write-Host "Re-Indexer deployed and run successfully.." -ForegroundColor DarkGreen
                $Output | Format-Table
            }
            else {
                Write-Host "Re-Indexer NOT deployed..." -ForegroundColor DarkRed
                $Output | Format-Table
            }
            break
        }
    }
}
Re-Indexer-Check