#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Creation d'une session pour activer remote Powershell
    $battery = Get-WmiObject -class win32_battery -property BatteryStatus | select-object BatteryStatus
    $battery.BatteryStatus
    if($battery.BatteryStatus -eq 2){
    "plugged in"
    }
    else{
    "on battery"
    }
#fermeture de la session remote PowerShell
Exit-PSSession 
}




