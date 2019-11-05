#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\Documents\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Creation d'une session pour activer remote Powershell
    Enter-PSSession $server -Authentication Negotiate 
    $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" |
    Select-Object Size,FreeSpace

    $disk.Size
    $disk.FreeSpace
    if ($disk.FreeSpace -gt 20000000000){
        "ok"
    }
    else{
    "error"
    }
#fermeture de la session remote PowerShell
Exit-PSSession 
}