$TestCSV = Test-Path P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\Kontoklaerung.csv
if($TestCSV -eq $true){
Write-Output "Datei existiert schon"
}else{
write-output "Kontenklaerung.xls wird zu Kontenklaerung.csv konvertiert"
Start-Process -Filepath "C:\Program Files\LibreOffice 5\program\soffice.exe" -ArgumentList "--convert-to csv ""P:\Kontenklaerung\Kontenklaerung.xls"" --headless --outdir $env:TMP" -Wait
write-output "Kontenklaerung.csv wird mit Spalten ergänzt"
Import-Csv "$env:TMP\Kontenklaerung.csv" | Select-Object *,@{Name='anhang';Expression={'P:\Kontenklaerung\send\KW'+$(get-date -UFormat %V)+'\' + $_.knr +'.pdf'}},@{Name='anmahnen';Expression={'nein'}},@{Name='datum';Expression={'YYYY-MM-DD'}},@{Name='status';Expression={'=SVERWEIS(x;y;z;0)'}},@{Name='stufe';Expression={'x'}} | Export-csv P:\Kontenklaerung\send\KW$(get-date -UFormat %V)\Kontenklaerung.csv -NoTypeInformation -Encoding UTF8 -Force
}