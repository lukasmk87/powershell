###################################
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

###################################
# Function to write fehlende Computer
###################################
function write_dpc ($Inhalt)
{
$FileExists = Test-Path $LogFilePc
    $DateNow = Get-Date -Format "dd.MM.yyyy HH:mm" 
    $FileInp = $Inhalt                          # Setzt die Zeile für unser Logfile zusammen
    If ($FileExists -eq $True){ # Wenn dir Datei existiert reinschreiben
        Add-Content $LogFilePc -value $FileInp
    } else {
       New-Item $LogFilePc -type file # Wenn dir Datei nicht existiert anlegen
       Add-Content $LogFilePc -value $FileInp # und reinschreiben
    }
}

$computers = Get-Content –Path \\'VERZEICHNIS'\Computers.txt
$software = Get-ChildItem \\'VERZEICHNIS'\deploy
$Logfile = "\\'VERZEICHNIS'\deployment.txt"
$LogFilePc = "\\'VERZEICHNIS'\dpc.txt"
$currentpc = [Environment]::MachineName
write_log "Ausgeführt von $currentpc"
foreach ($pc in $computers) {
    if(-not (Test-Connection -ComputerName $pc -Quiet)){
	write_log "$pc nicht erreichbar!"
	write_dpc "$pc"
	}
	else{
		write_log "$pc"
		write-output "$pc"
		foreach ($sw in $software){
			Copy-Item –Path $sw.FullName  -Destination  \\$pc\c$\Windows\Temp\ -Force -Recurse
		}
			if(Invoke-Command -ComputerName $pc {Get-Process -name "jp2launcher"}){
				write_log "Java auf $pc wird genutzt."
			}
				else{
					#write_log "Flash wird deinstalliert"
					#Invoke-Command -ComputerName $pc -FilePath \\$pc\c$\Windows\Temp\flashuninstall.ps1
					write-output "Java wird deinstalliert"
					sleep -Seconds 1
					write_log "Java wird deinstalliert"
					Invoke-Command -ComputerName $pc -FilePath \\$pc\c$\Windows\Temp\javauninstall.ps1
					write-output "Software wird auf $pc installiert"
					sleep -Seconds 1
					write_log "Software wird auf $pc installiert"
					Invoke-Command -ComputerName $pc -FilePath \\$pc\c$\Windows\Temp\Software.ps1
					write-output "Software wurde auf $pc installiert!"
					sleep -Seconds 1
					write_log "Software wurde auf $pc installiert!"
				}
	
	}
	#Remove-Item -Path "\\$pc\c$\Windows\Temp\" -Recurse -Force
}