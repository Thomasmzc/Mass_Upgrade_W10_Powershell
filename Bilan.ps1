
  $MANEPATH = "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\Delivery" #Chemin vers le dossier de l'iso et du script (ici le même dossier que le script)

  $Testpathlog = Test-Path "$MANEPATH\Logs" -PathType Container
  if($Testpathlog -like "True"){
    $Testpatherror = Test-Path "$MANEPATH\Logs\Erreurs" -PathType Container
    if($Testpatherror -like "True"){
        $Testpathsuccess = Test-Path "$MANEPATH\Logs\Succès" -PathType Container
         if($Testpathsuccess -like "True"){
          "Success : Logs folder alreay exist"
           $countererror = 0

           $DFSFolders = get-childitem -path "$MANEPATH\Logs\Erreurs" | where-object {$_.Psiscontainer -eq "True"} |select-object name

                #Loop through folders in Directory
                foreach ($DFSfolder in $DFSfolders)
                {
                $name = $DFSfolder.name
                $DFSFolders2 = get-childitem -path "$MANEPATH\Logs\Erreurs" | where-object {$_.Psiscontainer -eq "True"} |select-object name

                        

                   
                }
         }
         else{
            "Dossier Succcès introuvable"
         }
    }
    else{
        "Dossier Erreurs introuvable"
    }
  }
  else{
    "Dossier Logs introuvable"
  }
