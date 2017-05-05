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
function write_fpc ($Inhalt)
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

$computername = Get-Content –Path \\'VERZEICHNIS'\allComputers.txt
$Logfile = "\\'VERZEICHNIS'\inventar.txt"
$LogFilePc = "\\'VERZEICHNIS'\ipc.txt"
$currentpc = [Environment]::MachineName
write_log "Ausgeführt von $currentpc"
foreach ($pc in $computername) {
$osarch = (Get-WmiObject Win32_OperatingSystem -computername $pc).OSArchitecture
   if(-not (Test-Connection -ComputerName $pc -Quiet)){
   write_log "$pc nicht erreichbar!"
   write_fpc "$pc"
   }
    else{
        if ($osarch -eq "32-Bit"){
        Invoke-command -computername $pc {Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | sort -Property DisplayName | select-object DisplayName,DisplayVersion | Export-Csv -Path c:\Windows\temp\$(get-content env:computername).csv -NoTypeInformation} 
        }
            else{
                #Write-Host "$computername ist ein $osarch Windows" 
                #Write-Host "32-Bit Software"
                Invoke-command -computername $pc {Get-ItemProperty HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | sort -Property DisplayName | select-object DisplayName,DisplayVersion | Export-Csv -Path c:\Windows\temp\$(get-content env:computername)_32bit.csv -NoTypeInformation} 
                sleep -Seconds 1
				#Write-Host "64-Bit Software"
				Invoke-command -computername $pc {Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | sort -Property DisplayName | select-object DisplayName,DisplayVersion | Export-Csv -Path c:\Windows\temp\$(get-content env:computername)_64bit.csv -NoTypeInformation} 
				sleep -Seconds 1
			 }
                    Move-Item –Path \\$pc\c$\\Windows\temp\*.csv  -Destination \\bur-kg.org\dfs\Infrastruktur\inventar\ -Force
                    write_log "$pc wurde inventarisiert"
     }
    }

Write-Host "Inventarisierungsdateien wurden bereitgestellt"