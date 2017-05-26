$onlinebackup= "D:\DATEV\PROGRAMM\DBMSTOOL\DVPCDBMSCHECKCONSOLE711.EXE D:\DATEV\DATEN\DBMSTOOL\DATA01\STANDARD\STDMSCHECK_LOCALHOST.XML"

cmd /c $onlinebackup

Stop-Service -DisplayName "SQL Server (DATEV_DBENGINE)"

copy -r D:\DATEV\ D:\DATEV_SICHERUNG\DATEISICHERUNG\DATEV
copy -r D:\WINDSVSW1 D:\DATEV_SICHERUNG\DATEISICHERUNG\WINDSVSW1

Start-Service -DisplayName "SQL Server (DATEV_DBENGINE)"


set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
$date = Get-Date -Format yyyy-MM-dd

$Source = "D:\DATEV_SICHERUNG\"
$Target = "\\srvfs01\datastore-vol5\Datev_Sicherung\Sicherung_$date.zip"

sz a -mx=9 $Target $Source

Remove-Item $Source -Recurse -Force

Send-MailMessage -To "Lukas Kotowwicz <lukas.kotowicz@bur-kg.de>" -From "Datev Sicherung <datev.backup@bur-kg.de>" -Subject "Backup erfolgreich" -SmtpServer "smtp-relay.bur-kg.org"