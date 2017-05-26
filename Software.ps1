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
$Logfile = "\\bur-kg.org\dfs\Infrastruktur\logs\deployment.txt"
Start-Process C:\Windows\Temp\jre-8u121-windows-i586.exe -ArgumentList INSTALLCFG=C:\Windows\Temp\java-install.cfg -Wait -PassThru
#sleep -Seconds 5
#write_log "Java wurde installiert"
#Start-Process  Msiexec /qb! /i LibreOffice_5.2.0_Win_x86.msi /passive /norestart ALLUSERS=1 CREATEDESKTOPLINK=0 REGISTER_ALL_MSO_TYPES=1 REGISTER_NO_MSO_TYPES=1 ISCHECKFORPRODUCTUPDATES=0 QUICKSTART=1 ADDLOCAL=ALL UI_LANGS=de_DE
#sleep -Seconds 5
#write_log "LibreOffice 5.2 wurde installoert


#Start-Process -NoNewWindow msiexec -argument "/i C:\Windows\Temp\Deployment\AcroRdrDC1500720033_de_DE.msi /quiet" -Wait
#Start-Process -NoNewWindow msiexec -argument "/i C:\Windows\Temp\Deployment\d.3_smart_explorer.msi /quiet" -Wait
#Start-Process -NoNewWindow msiexec -argument "/i C:\Windows\Temp\Deployment\pdf24-creator-7.6.4.msi /quiet" -Wait
#Start-Process -NoNewWindow "$sharepath\gimp\gimp-2.8.10-setup.exe" -argument '/S' -Wait
#Start-Process -NoNewWindow "$sharepath\firefox\Firefox_Setup_44.0.2.exe" -argument '/S /V"/Passive /NoRestart"' -Wait
#Start-Process -NoNewWindow msiexec -argument "/i C:\Windows\Temp\Deployment\NativeClient2005\x86 -- 32 bit\sqlncli.msi /quiet" -Wait
#Start-Process -NoNewWindow msiexec -argument "/i C:\Windows\Temp\Deploymentsqlnclix86.msi /quiet" -Wait
#Start-Process -NoNewWindow msiexec -argument "/i $sharepath\officescan\Officescan.msi /quiet" -Wait
#Start-Process -NoNewWindow "$sharepath\notepad++\npp.6.9.Installer.exe" -argument '/S' -Wait
#Start-Process -NoNewWindow "$sharepath\vlc\vlc-2.2.2-win32.exe" -argument '/SILENT' -Wait

#msiexec /qb /i C:\Windows\Temp\Deployment\LibreOffice_5.2.0_Win_x86.msi UI_LANGS=de_DE Reboot=0 REGISTER_ALL_MSO_TYPES=1 QUICKSTART=1 ISCHECKFORPRODUCTUPDATES=0