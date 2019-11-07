﻿#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Creation d'une session pour activer remote Powershell
    Enter-PSSession $server -Authentication Negotiate 
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" |
    Select-Object Size,FreeSpace

    $disk.Size
    $diskspace = $disk.FreeSpace/1GB
    if ($diskspace -gt 20){
        "ok"
    }
    else{
    "error"
    }
#fermeture de la session remote PowerShell
Exit-PSSession 
}