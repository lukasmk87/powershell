function write_log ($Inhalt)
{
$FileExists = Test-Path $LogFile
 $DateNow = Get-Date -Format "dd-MM-yy HH:mm"
 $FileInp = $DateNow + ' | ' + $Inhalt # Setzt die Zeile für unser Logfile zusammen
 If ($FileExists -eq $True){ # Wenn dir Datei existiert reinschreiben
 Add-Content $LogFile -value $FileInp # Zeile hinten an die vorhanden Einträge anhängen
 } else {
 New-Item $Logfile -type file # Wenn dir Datei nicht existiert anlegen
 Add-Content $LogFile -value $FileInp # und reinschreiben
 }
}


$TestPath = Test-Path P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\
if($TestPath -eq $true){
write-output "Ordner existiert."
}else{
New-Item P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\ -ItemType Directory
}

$TestPath = Test-Path P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)
if($TestPath -eq $true){
write-output "Ordner existiert."
}else{
New-Item P:\Kontenklaerung\_sent\$(get-date -f yyMMdd) -ItemType Directory
}


$Logfile = "P:\Kontenklaerung\logs\log_$(get-date -f yyMMdd_HHmm).txt" 
$input = "P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\Kontenklaerung.csv"
$userListe = import-csv $input
$body = Get-Content -Path P:\Kontenklaerung\text_de_eng.txt | Out-String

# E-Mail wird versendet
foreach ($user in $userListe) {
if($user.anmahnen -match "ja" -or $user.anmahnen -notmatch $null){
Move-Item -Path ('P:\Kontenklaerung\_work\'+ $user.knr +'.pdf') -Destination P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\
write_log ('PDF für ' + $user.knr + ' wurde verschoben')
try{
if($user.adremail -eq $true){
Send-MailMessage -To $user.adremail -From "Max Mustermann <Max.Mustermann@muster.de>" -Subject ('Saldenabgleich K' + $user.knr) -Body $body -encoding ([System.Text.Encoding]::UTF8) -SmtpServer "smtp-relay.domain.lokal" -Attachments $user.anhang
write_log ('E-Mail1: ' + $user.adremail + ' wurde gewählt')
Move-Item -Path $user.anhang -Destination P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\
$newrow = New-Object PSObject -Property @{
   knr = ($user.knr)
   email = ($user.adremail)
   datum = (get-date -f yyyy-MM-dd)
   status = "gemahnt"
}
}Else{
Send-MailMessage -To $user.adremail2 -From "Max Mustermann <Max.Mustermann@muster.de>" -Subject ('Saldenabgleich K' + $user.knr) -Body $body -encoding ([System.Text.Encoding]::UTF8) -SmtpServer "smtp-relay.domain.lokal" -Attachments $user.anhang
Write_log ('E-Mail2: ' + $user.adremail2 + ' wurde gewählt')
Move-Item -Path $user.anhang -Destination P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\
$newrow = New-Object PSObject -Property @{
   knr = ($user.knr)
   email = ($user.adremail2)
   datum = (get-date -f yyyy-MM-dd)
   status = "gemahnt"
}
}

}
catch [System.IO.FileNotFoundException ],[Microsoft.PowerShell.Commands.SendMailMessage]
{
Write_log ('Mail an Kunde: ' + $user.knr + ' konnte nicht versendet werden')
}
write_log ('Mail an Kunde: ' + $user.knr + ' wurde versendet')
}
}
Start-Sleep -s 2
$newrow | select knr,email,datum,status | Export-Csv P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\gesendet.csv -notypeinformation
Start-Sleep -s 2
Move-Item -Path $Logfile -Destination P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\
Start-Sleep -s 2
Copy-Item -Path P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\Kontenklaerung.csv -Destination P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\Kontenklaerung_$(get-date -f yyMMdd).csv
Start-Sleep -s 2
# Ordner wird archiviert
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"  

$Source = "P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\*.*" 
$Target = "P:\Kontenklaerung\_sent\$(get-date -f yyMMdd).zip"

sz a -mx=9 $Target $Source
