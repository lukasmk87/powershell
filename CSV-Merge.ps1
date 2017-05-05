function Merge-CSVFiles {            
[cmdletbinding()]            
param(            
    [string[]]$CSVFiles,            
    [string]$OutputFile = "c:\merged.csv"            
)            
$Output = @();            
foreach($CSV in $CSVFiles) {            
    if(Test-Path $CSV) {            
                    
        $FileName = [System.IO.Path]::GetFileName($CSV)            
        $temp = Import-CSV -Path $CSV          
        $Output += $temp            
            
    } else {            
        Write-Warning "$CSV : No such file found"            
    }            
            
}            
$Output | Export-Csv -Path $OutputFile -NoTypeInformation            
Write-Output "$OutputFile wurde erstellt"            
            
}   

Merge-CSVFiles -CSVFiles c:\Windows\temp\a.csv,c:\Windows\temp\b.csv,c:\Windows\temp\c.csv,c:\Windows\temp\d.csv -OutputFile c:\Windows\temp\_all.csv