"Setup completed successfully"
#VARIABLES A ADAPTER

#A enlever plus tard :
$Testname = "Test_local0"

#A garder : 
$MANEPATH = (Get-Item -Path ".\").FullName #Chemin vers le dossier de l'iso et du script
$server = $env:COMPUTERNAME

#Test et création si nécessaire du dossier au nom du poste dans le répertoire succès
$Testpathnamepost = Test-Path "$MANEPATH\Logs\Succès\$server" -PathType Container
if($Testpathnamepost -like "True"){
  "Success : Logs folder named with namepost alreay exist"
}
else{
  New-Item -Path "$MANEPATH\Logs\Succès\$server" -ItemType directory
}
#Ajout du succès dans les logs
ADD-content -path "$MANEPATH\Logs\Succès\$server\$server.txt" -value "Success : Setup completed, ready for tests."

#Lancement des scripts post-upgrade : 
#reg files
reg import "$MANEPATH\Post_Upgrade\HKU_DefaultUser.reg"
reg import "$MANEPATH\Post_Upgrade\PhotoViewer.reg"
reg import "$MANEPATH\Post_Upgrade\HKLM_DefaultSoftware.reg"

ADD-content -path "$MANEPATH\Logs\Succès\$server\$server.txt" -value "Success : Post-Setup scripts have been executed."

#Copie du répertore des logs vers le serveur distant
#Chemin de la destination (a modifier)
$DestPath =  "\\FRPF13QXR1\C$\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\$Testname\"

#Chemin vers la source
$SourcePath = "$MANEPATH\Logs"

#Creer un novueau dossier au nom du poste dans le serveur distant

$cred = Get-Credential -Credential 'lan.ccfr\TMAZECOL'
New-PSDrive -Name NewPSDrive -PSProvider FileSystem -Root \\FRPF13QXR1\C$\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\$Testname\ -Credential $cred
New-Item -ItemType Directory NewPSDrive -Force
#New-Item -Path $DestPath -ItemType directory

#Copier le contenu du dossier source vers le nouveau dossier sur le serveur distant
Copy-Item -Recurse -Path $SourcePath -destination $DestPath 
