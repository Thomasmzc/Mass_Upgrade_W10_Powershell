#Récupère la liste des postes à distance :
$server_names = Get-Content "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\computers.txt"
#Pour chaque postes de la liste :
Foreach ($server in $server_names){
    #Chemin vers repertoire des erreurs.
    $path = "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\Delivery\Logs\Erreurs\"+$server+".txt"
    #test s'il exist déjà des erreurs pour ce poste
    $testexist = [System.IO.File]::Exists($path)
    $testexist
    if($testexist -like "False"){
        #aucune erreur pour ce poste
        $statelog = "clear"
    }
    else{
        #il y a deja des erreurs pour ce poste
        $statelog = "not empty"
    }
    $statelog
}
