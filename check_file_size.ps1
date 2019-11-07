#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    "working on "+$server
    #Creation d'une session pour activer remote Powershell
    Enter-PSSession $server -Authentication Negotiate 
    $file = 'C:\bac_a_sable'
Write-Host((Get-Item $file).length/1KB)
Write-Host((Get-Item $file).length/1MB)
Write-Host((Get-Item $file).length/1GB)
#fermeture de la session remote PowerShell
Exit-PSSession 
}
