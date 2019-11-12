#VARIABLES A ADAPTER

  #A enlever plus tard :
  $Testname = "Test_local0"

  #A garder : 

  $MANEPATH = (Get-Item -Path ".\").FullName #Chemin vers le dossier de l'iso et du script
  $pathISO = "$MANEPATH\fr_windows_10_business_editions_version_1909_x64_dvd_56950d6e.iso" #Chemin vers l'ISO brut
  $Typeco = "Ethernet0" #type de connection internet requis
  $diskname = "C:" #nom du disque

  $server = $env:COMPUTERNAME


  #Chemin vers repertoire des erreurs.
  $path = "$MANEPATH\Logs\Erreurs\"+$server+".txt"

  $Testpathlog = Test-Path "$MANEPATH\Logs" -PathType Container
  if($Testpathlog -like "True"){
    $Testpatherror = Test-Path "$MANEPATH\Logs\Erreurs" -PathType Container
    if($Testpatherror -like "True"){
        $Testpathsuccess = Test-Path "$MANEPATH\Logs\Succès" -PathType Container
         if($Testpathsuccess -like "True"){
          "Success : Logs folder alreay exist"
         }
         else{
            New-Item -Path "$MANEPATH\Logs\Succès\" -ItemType directory
         }
    }
    else{
        New-Item -Path "$MANEPATH\Logs\Erreurs\" -ItemType directory
    }
  }
  else{
    New-Item -Path "$MANEPATH\Logs\" -ItemType directory
    New-Item -Path "$MANEPATH\Logs\Erreurs\" -ItemType directory
    New-Item -Path "$MANEPATH\Logs\Succès\" -ItemType directory
  }


#Test et création si nécessaire du dossier au nom du poste dans le répertoire Erreurs

  $Testpathnamepost = Test-Path "$MANEPATH\Logs\Erreurs\$server" -PathType Container
  if($Testpathnamepost -like "True"){
    "Success : Logs folder named with namepost alreay exist"
  }
  else{
    New-Item -Path "$MANEPATH\Logs\Erreurs\$server" -ItemType directory
  }


  #Test présence de l'iso
  
  $Testpathiso = Test-Path $pathISO
  if($Testpathiso -like "True"){
    "Success : I have found the ISO file"

    #test s'il existe déjà des erreurs pour ce poste

    $testexist = [System.IO.File]::Exists($path)
    if($testexist -like "False"){
        #aucune erreur pour ce poste
        $statelog = "clear for existing logs"
    }
    else{
        #il y a deja des erreurs pour ce poste
        $statelog = "WARNING : previous errors detected"
        ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "-------------------------NEW LAUNCH------------------"
    }
    $statelog
    
    #Test de l'Etat de la connection internet

    $conection = Test-NetConnection  | Select-Object -Property InterfaceAlias
    $conection = $conection.psobject.properties | % {$_.Value}
    $conection2 = Test-NetConnection  | Select-Object -Property PingSucceeded
    $conection2 = $conection2.psobject.properties | % {$_.Value}
    $conection2
    if($conection2 -like "True"){
        "network conected, let's check the type"
         if($conection -eq $Typeco){
        "ok for connection test"
        
        #Test Laptop ou Desktop

        if(Get-WmiObject -Class win32_battery)
        { 
            #Si c'est un laptop, on test l'etat de la batterie
            $isLaptop = $true 
            $battery = Get-WmiObject -class win32_battery -property BatteryStatus | select-object BatteryStatus
            $testbattery = $battery.BatteryStatus
        }
        else{ 
            #si c'est un desktop, on défini l'état de la batterie à "branchée"
            $islaptop = $false
            $testbattery = 2
        }

        # Test de l'état de la batterie 

        if($testbattery -eq 2){
            "plugged in"

            # Test de l'espace libre sur le disque

            $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$diskname'" |
            Select-Object Size,FreeSpace

            $diskspace = $disk.FreeSpace/1GB
            if ($diskspace -gt 20){
                "Success : Enough space"

                # Si test de la taille de l'iso, placer ici.

                     #Creer dossier Upgrade

                     New-Item -Path "$MANEPATH\Upgrade\" -ItemType directory

                     #Créer install.cmd qui contient setup.exe

                     $Testpathinstall = Test-Path "$MANEPATH\Upgrade\install.cmd"
                     if($Testpathinstall -like "True"){
                      Remove-Item -Path "$MANEPATH\Upgrade\install.cmd"
                     }
                     else{
                     }
                      #ADD-content -path "$MANEPATH\Upgrade\install.cmd" -value "cd $MANEPATH\Upgrade"
                      #ADD-content -path "$MANEPATH\Upgrade\install.cmd" -value "start Win10\setup.exe /Auto Upgrade /Compat ScanOnly /ShowOOBE none /BitLocker TryKeepActive"
                        Set-Content -Path "$MANEPATH\Upgrade\install.cmd" -Value "@echo off" -Force
                        Add-Content -Path "$MANEPATH\Upgrade\install.cmd" -Value "$MANEPATH\Upgrade\Win10\setup.exe /Auto Upgrade /Quiet /ShowOOBE none /BitLocker TryKeepActive /migratedrivers all /postoobe $MANEPATH\setupcomplete.cmd /copylogs $MANEPATH\Logs\Erreurs\$server" -Force
                        Add-Content -Path "$MANEPATH\Upgrade\install.cmd" -Value "echo %ERRORLEVEL% > $MANEPATH\Logs\Erreurs\$server\upgrade.txt" -Force
                        Get-Content -Path "$MANEPATH\Upgrade\install.cmd"

                      #Creation du SetupComplete.cmd qui va se lancer une fois l'install finie, et qui va executer le script PowerShell "post_setup.ps1"
                      ADD-content -path "$MANEPATH\SetupComplete.cmd" -value "Powershell.exe Set-ExecutionPolicy Unrestricted -Scope currentUser"
                      ADD-content -path "$MANEPATH\SetupComplete.cmd" -value "Powershell.exe -File $MANEPATH\post_setup.ps1 -WindowStyle Hidden "
                        #Extraire fichiers de l'image disque dans un dossier nommé Win10 placé au même endroit que install.cmd
                        $original_folder = "Upgrade\"
                        cd $MANEPATH

                        $list = ls *.iso | Get-ChildItem -rec | ForEach-Object -Process {$_.FullName}

                        foreach($iso in $list){
                            $folder = "Upgrade\Win10"
                            if((Test-Path $folder) -and $overwrite -eq $false)
                            {
                                  ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "WARNING : $folder n'a pas été traité, le fichier existait déjà."
                            }
                            else
                            {
                                if(Test-Path $folder)
                                {
                                    rm $folder -Recurse
                                }
                                $mount_params = @{ImagePath = $iso; PassThru = $true; ErrorAction = "Ignore"}
                                $mount = Mount-DiskImage @mount_params
                                if($mount) {
                                    $volume = Get-DiskImage -ImagePath $mount.ImagePath | Get-Volume
                                    $source = $volume.DriveLetter + ":\*"
                                    $folder = mkdir $folder
                                    Write-Host "Extracting '$iso' to '$folder'..."
                                    $params = @{Path = $source; Destination = $folder; Recurse = $true;}
                                    cp @params
                                    $hide = Dismount-DiskImage @mount_params
                                    Write-Host "Copy complete"
                                }
                                else{
                                    ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "Fail : Impossible de monter $iso, le fichier est peut-être déjà en cours d'utilisation."
                                }
                            }
                        }

                        cd $original_folder
                        
                        #Lancement du Setup.exe
                        Invoke-Item "$MANEPATH\Upgrade\install.cmd"
                        # Start-Process -Wait `
                                        # -PSPath "PsExec.exe"  `
                                        # -ArgumentList "$MANEPATH\Upgrade\install.cmd -h -d" `
                                        # -RedirectStandardError "$MANEPATH\Logs\Erreurs\$server\error.log" `
                                        # -RedirectStandardOutput "$MANEPATH\Logs\Erreurs\$server\output.log"
                           # Get-Content -Path "$MANEPATH\Logs\Erreurs\$server\error.log"
            }
            else{
                ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "Fail : Le post ne dispose pas de 20GB d'espace libre sur le disque C"
                "Error : Less than 20GB Freespace on disque"
            }
        }
        else{
                ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "Fail : Le post était sur batterie."
                "ERROR : on battery"
            
        }
    }
    else{
        ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "Test de l'espace libre"
        "ERROR : pas ok pour connection test"
    }
    }
    else{
        ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "Fail : aucune connexion à internet"
        "ERROR : pas de connectio à internet"
    }
   
  }
  else{
    ADD-content -path "$MANEPATH\Logs\Erreurs\$server\$server.txt" -value "Fail : ISO pas présent."
        "ERROR : L'ISO n'est pas présent."
  }
