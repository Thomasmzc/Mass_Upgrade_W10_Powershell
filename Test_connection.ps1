#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\Documents\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Creation d'une session pour activer remote Powershell
    Enter-PSSession $server -Authentication Negotiate 
    #Get-NetAdapter -Name "*" -IncludeHidden
    Test-NetConnection
#fermeture de la session remote PowerShell
Exit-PSSession 
}