# Ordner anlegen

$TestPath = Test-Path C:\Script\
if($TestPath -eq $true){
write-output "Ordner existiert."
}else{
New-Item C:\Script\ -ItemType Directory
}

# Start-Transcript
Start-Transcript -path C:/Script/PingLog.txt -Append

#Ping
Ping.exe -t 8.8.8.8 | ForEach {"{0} - {1}" -f (Get-Date),$_}