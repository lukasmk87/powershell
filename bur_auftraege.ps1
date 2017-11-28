$Date = Get-Date -Format "ddMMyyyy"

$TestPath = Test-Path C:\Users\lukaskotowicz.BUR-KG\Desktop\bur_auftraege\neu\$Date\
if($TestPath -eq $true){
write-output "Ordner existiert."
}else{
New-Item C:\Users\lukaskotowicz.BUR-KG\Desktop\bur_auftraege\neu\$Date\ -ItemType Directory
}

#Define locations and delimiter
$csv = "C:\Users\lukaskotowicz.BUR-KG\Desktop\bur_auftraege\neu\ADVEXPRT281120171520.CSV" #Location of the source file
#$csv = "V:\erp\adveotool\04102017\1501\ADVEXPRT041020171501.CSV" #Location of the source file
$csvexport = "C:\Users\lukaskotowicz.BUR-KG\Desktop\bur_auftraege\test\temp.csv" #Desired location of output
#$csvexport = "V:\erp\adveotool\temp\temp.csv" #Desired location of output
$burauftraege ="C:\Users\lukaskotowicz.BUR-KG\Desktop\bur_auftraege\neu\$Date\bur_auftraege.csv"
#$burauftraege ="V:\erp\adveotool\$(get-date -f ddMMyyyy)\bur_auftraege.csv"
$delimiter = ";" #Specify the delimiter used in the file
$mail = "lukas@kotowicz.info"

Remove-Item $csvexport -Force

# Create a new Excel workbook with one empty sheet
$excel = New-Object -ComObject excel.application 
$workbook = $excel.Workbooks.Add(1)
$worksheet = $workbook.worksheets.Item(1)

# Build the QueryTables.Add command and reformat the data
$TxtConnector = ("TEXT;" + $csv)
$Connector = $worksheet.QueryTables.add($TxtConnector,$worksheet.Range("A1"))
$query = $worksheet.QueryTables.item($Connector.name)
$query.TextFileOtherDelimiter = $delimiter
$query.TextFileParseType  = 1
$query.TextFileColumnDataTypes = ,2 * $worksheet.Cells.Columns.Count
$query.AdjustColumnWidth = 1
$query.TextFilePlatform = 850
$query.TextFileTextQualifier = 2

# Execute & delete the import query
$query.Refresh()
$query.Delete()

# Save & close the Workbook as XLSX.
$Workbook.SaveAs($csvexport,23)
$excel.Quit()


Get-Content $csvexport | ForEach-Object {$_ -replace "zuname1","zunamei"} | ForEach-Object {$_ -replace "zuname2","zunameii"} |ForEach-Object {$_ -replace "'",""} |ForEach-Object {$_ -replace "null",""}| Set-Content -Encoding UTF8 $burauftraege

