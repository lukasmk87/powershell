function Monitor {
$Monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi

ForEach ($Monitor in $Monitors)
{
	$user = ((Get-WmiObject Win32_ComputerSystem).UserName | ForEach{[char]$_}) -join ""
	$Manufacturer = ($Monitor.ManufacturerName -notmatch 0 | ForEach{[char]$_}) -join ""
    $Name = ($Monitor.UserFriendlyName -notmatch 0 | ForEach{[char]$_}) -join ""
	
if($Manufacturer -match "ACR"){$Manufacturer = "Acer"}
Elseif($Manufacturer -match "HSD"){$Manufacturer = "Hanns-G"}

if($Name -match "V46HL"){$Name = "V246HL"}
Elseif($Name -match "HL5DB"){$Name = "HL225"}


$obj = New-Object PSObject
$obj = Add-Member NoteProperty Benutzername $user 
$obj | Add-Member NoteProperty Geraetebezeichnung $Name 
$obj | Add-Member NoteProperty Hersteller $Manufacturer	

Write-Output $obj
}
}

 Monitor | Export-Csv -Path c:\Windows\temp\$(get-content env:computername)MON.csv -NoTypeInformation