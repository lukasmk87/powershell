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
$Logfile = "\\bur-kg.org\dfs\Infrastruktur\logs\uninstall.txt"
#unistall flash 
$ErrorActionPreference = "Stop"
$flash = Get-WmiObject -Class win32_product | where { $_.Name -like "*Flash*"}
$msiexec = "C:\Windows\system32\msiexec.exe";
$msiexecargs = '/x "$($app.IdentifyingNumber)" /qn /norestart'

if ($flash -ne $null)
{
    foreach ($app in $flash)
    {
		Write-Host "Flash wird deinstalliert..."
		&C:\Windows\system32\cmd.exe /c "C:\Windows\system32\msiexec.exe /x $($app.IdentifyingNumber) /qn"
		Start-Process -FilePath $msiexec -Arg $msiexecargs -Wait -Passthru
		[Diagnostics.Process]::Start($msiexec, $msiexecargs);
		write_log "Flash wurde deinstalliert."
	}
}
else {write-host "Flash wurde nicht gefunden!"}