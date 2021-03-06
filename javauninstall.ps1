﻿###################################
# Function to write Logfile
###################################
function write_log ($Inhalt)
{
$FileExists = Test-Path $LogFile
    $DateNow = Get-Date -Format "dd.MM.yyyy HH:mm" 
    $FileInp = $DateNow + ' | ' + $Inhalt                          # Setzt die Zeile für unser Logfile zusammen
    If ($FileExists -eq $True){ # Wenn dir Datei existiert reinschreiben
        Add-Content $LogFile -value $FileInp  # Zeile hinten an die vorhanden Einträge anhängen
    } else {
       New-Item $Logfile -type file # Wenn dir Datei nicht existiert anlegen
       Add-Content $LogFile -value $FileInp # und reinschreiben
    }
}
$Logfile = "\\domain.tld\dfs\Infrastruktur\logs\deployment.txt"
#unistall java 
$ErrorActionPreference = "Stop"
$java = Get-WmiObject -Class win32_product | where { $_.Name -like "*Java*"}
$msiexec = "C:\Windows\system32\msiexec.exe";
$msiexecargs = '/x "$($app.IdentifyingNumber)" /qn /norestart'
if ($java -ne $null){
	foreach ($app in $java){
			&C:\Windows\system32\cmd.exe /c "C:\Windows\system32\msiexec.exe /x $($app.IdentifyingNumber) /qn"
			[Diagnostics.Process]::Start($msiexec, $msiexecargs);
			write_log "alte Versionen von Java wurde deinstalliert."
			}
}
 else {write_log "Java nicht gefunden."}
					
