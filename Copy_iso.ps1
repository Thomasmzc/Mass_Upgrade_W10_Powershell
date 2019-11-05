#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Creation d'une session pour activer remote Powershell
    $session = New-PSSession $server -Authentication Negotiate -Credential TMAZECOL
    #Copie du fichier sur le post cible
    Copy-Item -Path "C:\Users\TMAZECOL\Downloads\fr_windows_10_multi-edition_version_1709_updated_sept_2017_x64_dvd_100090825.iso" -Destination C:\bac_a_sable\fr_windows_10_multi-edition_version_1709_updated_sept_2017_x64_dvd_100090825.iso -ToSession $session
#fermeture de la session remote PowerShell
Exit-PSSession 
}
