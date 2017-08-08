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

$computername = Get-Content –Path C:\Scripts\Computers.txt
$Logfile = "C:\Scripts\inventar.txt"
$LogFilePc = "C:\Scripts\ipc.txt"
$currentpc = [Environment]::MachineName
write_log "Ausgeführt von $currentpc"
foreach ($pc in $computername) {
   if(-not (Test-Connection -ComputerName $pc -Quiet)){
   write_log "$pc nicht erreichbar!"
   write_fpc "$pc"
   }
    else{
       Invoke-command -computername $pc {Get-WmiObject Win32_Computersystem -computername $pc | select-object Name, Manufacturer,Model Export-Csv -Path c:\Windows\temp\$(get-content env:computername).csv -NoTypeInformation} 
        }
           Move-Item –Path \\$pc\c$\\Windows\temp\*.csv  -Destination \\MNSPLUSDC\allPC\ -Force
           write_log "$pc wurde inventarisiert"
}
Write-Host "Inventarisierungsdateien wurden bereitgestellt"