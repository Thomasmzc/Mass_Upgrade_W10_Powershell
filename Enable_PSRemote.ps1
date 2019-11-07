$PSExec = "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\psexec.exe"
$server_names = Get-Content "C:\Users\TMAZECOL\OneDrive - COMPUTACENTER\Documents\PowerShell_Installation_Windows10\bac_a_sable\computers.txt"
$user = "TMAZECOL"  
$pass = "Clem291119"
$command ="enable-psremoting -force"
 Foreach ($server in $server_names){
 Start-Process -Filepath "$PSExec" -ArgumentList "\\$server -u $user -p $pass -h -d powershell.exe $command"
 }

