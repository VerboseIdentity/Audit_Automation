Clear-Host
function WIP_Stats{
        
    Write-Host "`nChecking WIP stats..`n---------------------"
    $Query = "Use Works
    EXEC sp_autostats 'Wip_ABN_Status'; 
    EXEC sp_autostats 'WIP_additional_information'; 
    EXEC sp_autostats 'WIP_Allergy'; 
    EXEC sp_autostats 'WIP_Annotation'; 
    EXEC sp_autostats 'WIP_CarePlan'; 
    EXEC sp_autostats 'WIP_Charge_ABN'; 
    EXEC sp_autostats 'WIP_Education'; 
    EXEC sp_autostats 'WIP_Education_Factor'; 
    EXEC sp_autostats 'WIP_EducationSession'; 
    EXEC sp_autostats 'WIP_Flow_Class_Flow'; 
    EXEC sp_autostats 'WIP_Flowsheet'; 
    EXEC sp_autostats 'WIP_Flowsheet_Class'; 
    EXEC sp_autostats 'WIP_Flowsheet_Row'; 
    EXEC sp_autostats 'WIP_Flowsheet_Specialty_Map'; 
    EXEC sp_autostats 'WIP_Flowsheet_Specialty_Problem_Map'; 
    EXEC sp_autostats 'WIP_Goal'; 
    EXEC sp_autostats 'WIP_HMP'; 
    EXEC sp_autostats 'WIP_Medication'; 
    EXEC sp_autostats 'WIP_Medication_EXT'; 
    EXEC sp_autostats 'WIP_Order_ClinicalItem_Mapper'; 
    EXEC sp_autostats 'WIP_Order_Document_Mapper'; 
    EXEC sp_autostats 'WIP_Order_Item_Charge'; 
    EXEC sp_autostats 'WIP_Pending_Order_Status_Reason'; 
    EXEC sp_autostats 'WIP_Plan_Item_Instruction_Variable'; 
    EXEC sp_autostats 'WIP_Recommendation'; 
    EXEC sp_autostats 'WIP_Schedule'; 
    EXEC sp_autostats 'WIP_Session_Detail'; 
    EXEC sp_autostats 'WIP_Session_Manager'; 
    EXEC sp_autostats 'WIP_Vendor_Item'; 
    EXEC sp_autostats 'WIP_Vendor_Item_Extension'; 
    EXEC sp_autostats 'WIP_Works_Note_Content_Item'; 
    EXEC sp_autostats 'WIP_Works_Note_Image_Item'; 
    EXEC sp_autostats 'WIP_Works_Note_Text_Item'; 
    EXEC sp_autostats 'WIPABN'; 
    EXEC sp_autostats 'WIPFinding'; 
    EXEC sp_autostats 'WIPImmunization'; 
    EXEC sp_autostats 'WIPImmunization_EXT'; 
    EXEC sp_autostats 'WIPOrder'; 
    EXEC sp_autostats 'WIPOrder_EXT'; 
    EXEC sp_autostats 'WIPProblem'; 
    EXEC sp_autostats 'WIPResult'; 
    EXEC sp_autostats 'WIPSession';"

    $config_data = Import-Clixml -Path .\Database\Config.xml

    $Username = $config_data.sql_Username
    $Password = $config_data.sql_Password
    $instance = $config_data.sql_instance
    $Servers = Get-content -Path ".\Servers.txt"
    foreach($Server in $Servers){
        if ($Server.split(",")[1] -eq "DB") {
            $target = $Server.split(",")[0]
            $WIP_Status =Invoke-Command -ComputerName $target -ScriptBlock{
                Invoke-Sqlcmd -ServerInstance $Using:instance -Username $Using:Username -Password $Using:Password -Query $Using:Query
            }
            $WIP_Status_Off = $WIP_Status | Select-Object 'Index Name','AUTOSTATS','Last Updated' | Where-Object {$_.AUTOSTATS -match 'OFF'} | Format-Table -AutoSize | Out-String
            $WIP_Status_On = $WIP_Status | Select-Object 'Index Name','AUTOSTATS','Last Updated' | Where-Object {$_.AUTOSTATS -match 'ON'} | Format-Table -AutoSize | Out-String
    
            if($WIP_Status_On){
    
                Write-Host "Below WIP Stats are set to ON, please turn them OFF"
                Write-Host $WIP_Status_On -ForegroundColor Red
            }
            else {
                Write-Host "WIP Stats were set to OFF"
                Write-Host $WIP_Status_Off -ForegroundColor Green
            }
        }
        break
    }
}
WIP_Stats