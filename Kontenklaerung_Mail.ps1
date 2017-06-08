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

# Dateien zum versenden vorbereiten
foreach ($user in $userListe) {
if($user.anmahnen -match "ja" -or $user.anmahnen -notmatch $null){
Move-Item -Path ('P:\Kontenklaerung\_work\'+ $user.knr +'.pdf') -Destination P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\
write_log ('PDF für ' + $user.knr + ' wurde verschoben')

#Anschreiben wird gewählt
switch($user.stufe){
1{$body = Get-Content -Path P:\Kontenklaerung\text1_de_eng.txt | Out-String}
2{$body = Get-Content -Path P:\Kontenklaerung\test2_de_eng.txt | Out-String}
}

#Betreff wird gewählt
switch($user.stufe){
1{$betreff = 'Saldenabgleich K' + $user.knr}
2{$betreff = 'Zahlungsaufforderung - drohende Liefersperre K' + $user.knr}
}

#E-Mailversand
Send-MailMessage -To $user.adremail2 -From "Dummy <du.ummy@domian.tld>" -Subject $betreff -Body $body -encoding ([System.Text.Encoding]::UTF8) -SmtpServer "smtp-relay.domain.tld" -Attachments $user.anhang
write_log ('E-Mail für K:'+ $user.knr + ' wurde an: '  + $user.adremail + ' gesendet.')
Move-Item -Path $user.anhang -Destination P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\
}
}
# 2 Sekunden warten
Start-Sleep -s 2
# Logdatei verschieben
Move-Item -Path $Logfile -Destination P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\
# 2 Sekunden warten
Start-Sleep -s 2
# verarbeitete CSV kopieren
Copy-Item -Path P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\Kontenklaerung.csv -Destination P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\Kontenklaerung_$(get-date -f yyMMdd).csv
# 2 Sekunden warten
Start-Sleep -s 2
# Ordner wird archiviert
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"  

$Source = "P:\Kontenklaerung\_sent\$(get-date -f yyMMdd)\*.*" 
$Target = "P:\Kontenklaerung\_sent\$(get-date -f yyMMdd).zip"

sz a -mx=9 $Target $Source
