#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\Documents\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Creation d'une session pour activer remote Powershell
    Enter-PSSession $server -Authentication Negotiate 
    $file = 'C:\bac_a_sable\fr_windows_10_multi-edition_version_1709_updated_sept_2017_x64_dvd_100090825.iso'
Write-Host((Get-Item $file).length/1KB)
Write-Host((Get-Item $file).length/1MB)
Write-Host((Get-Item $file).length/1GB)
#fermeture de la session remote PowerShell
Exit-PSSession 
}
