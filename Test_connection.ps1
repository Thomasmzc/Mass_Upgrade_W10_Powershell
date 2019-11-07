#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Creation d'une session pour activer remote Powershell
    Enter-PSSession DESKTOP-J09MTL3 -Authentication Negotiate 
    #Get-NetAdapter -Name "*" -IncludeHidden
    $conection = Test-NetConnection  | Select-Object -Property InterfaceAlias
    $conection = $conection.psobject.properties | % {$_.Value}
    if($conection -eq "Ethernet"){
    "ok"
    }
    else{
    "pas ok"
    }
#fermeture de la session remote PowerShell
Exit-PSSession 
}