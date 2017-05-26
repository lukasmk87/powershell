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

Merge-CSVFiles -CSVFiles c:\Windows\temp\$(get-content env:computername)HW.csv,c:\Windows\temp\$(get-content env:computername)Graka.csv,c:\Windows\temp\$(get-content env:computername)MON.csv -OutputFile c:\Windows\temp\$(get-content env:computername)_all.csv