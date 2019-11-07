  $Testname = "Test_local0"
  $pathISO = "C:\Users\TMAZECOL\Downloads\Windows10_InsiderPreview_Client_x64_fr-fr_18363.iso"
  $MANEPATH = "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\Delivery"
  $server = $env:COMPUTERNAME
    #Chemin vers repertoire des erreurs.
    $path = "$MANEPATH\Logs\Erreurs\"+$server+".txt"
    #test s'il exist déjà des erreurs pour ce poste
    $testexist = [System.IO.File]::Exists($path)
    if($testexist -like "False"){
        #aucune erreur pour ce poste
        $statelog = "clear for existing logs"
    }
    else{
        #il y a deja des erreurs pour ce poste
        $statelog = "WARNING : previous errors detected"
        ADD-content -path "$MANEPATH\Logs\Erreurs\$server.txt" -value "-------------------------NEW LAUNCH------------------"
    }
    $statelog
    #Get-NetAdapter -Name "*" -IncludeHidden
    $conection = Test-NetConnection  | Select-Object -Property InterfaceAlias
    $conection = $conection.psobject.properties | % {$_.Value}
    if($conection -eq "Ethernet"){
        "ok for connection test"
        $battery = Get-WmiObject -class win32_battery -property BatteryStatus | select-object BatteryStatus
        if($battery.BatteryStatus -eq 2){
            "plugged in"
            $disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" |
            Select-Object Size,FreeSpace

            $diskspace = $disk.FreeSpace/1GB
            if ($diskspace -gt 20){
                "Success : Enough space"
                $file = "$MANEPATH\Ressources\Windows10_InsiderPreview_Client_x64_fr-fr_18363.iso"
                $sizefile =(Get-Item $file).length/1GB
                $sizeOriginalISO = (Get-Item $pathISO).length/1GB
                if($sizefile -eq $sizeOriginalISO){
                     "Success : well copied"
                     #Creer dossier Upgrade
                     New-Item -Path "$MANEPATH\Upgrade\" -ItemType directory
                     #Créer install.cmd qui contient setup.exe
                     ADD-content -path "$MANEPATH\Upgrade\install.cmd" -value "cd $MANEPATH"
                      ADD-content -path "$MANEPATH\Upgrade\install.cmd" -value "start /wait Win10\setup.exe /auto upgrade /migratedrivers all /dynamicupdate enable /showoobe none"
                        #Extraire fichiers de l'image disque dans un dossier nommé Win10 placé au même endroit que install.cmd
                        $original_folder = "Upgrade\"
                        cd "C:\bac_a_sable"

                        $list = ls *.iso | Get-ChildItem -rec | ForEach-Object -Process {$_.FullName}

                        foreach($iso in $list){

                        $folder = "Win10"
                        if((Test-Path $folder) -and $overwrite -eq $false)
                        {
                              Write-Host "WARNING: Skipping '$folder', reason: target path already exists"
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
                            else {
                                 Write-Host "ERROR: Could not mount " $iso " check if file is already in use"
                            }
                            }
                        }

                        cd $original_folder

                        Invoke-Item C:\bac_a_sable\Upgrade\install.cmd
                else{
                    "ERROR : bad copy"
                    ADD-content -path "$MANEPATH\Logs\Erreurs\$server.txt" -value "Fail : L'ISO copié n'a pas la même taille que l'ISO original"
                }
            }
            else{
                ADD-content -path "$MANEPATH\Logs\Erreurs\$server.txt" -value "Fail : Le post ne dispose pas de 20GB d'espace libre sur le disque C"
                "Error : Less than 20GB Freespace on disque"
            }
        }
        else{
                ADD-content -path "$MANEPATH\Logs\Erreurs\$server.txt" -value "Fail : Le post était sur batterie."
                "ERROR : on battery"
            
        }
    }
    else{
        ADD-content -path "$MANEPATH\Logs\Erreurs\$server.txt" -value "Fail : Le post n'était pas connecté par cable au réseau"
        "ERROR : pas ok pour connection test"
    }
 #Defining Source and Destination path
$DestPath =  "\\DESKTOP-EPQSHTM\C$\$Testname\"
$SourcePath = "$MANEPATH\Logs"

#Creating new folder for storing backup
New-Item -Path $DestPath -ItemType directory

#Copying folder
Copy-Item -Recurse -Path $SourcePath -destination $DestPath 
