$datei1= Import-CSV 'C:\Users\lukaskotowicz.BUR-KG\Desktop\zahlweg_verteilung_von_160401_bis_170207.csv' | sort bnr -Descending
$datei2= Import-CSV 'C:\Users\lukaskotowicz.BUR-KG\Desktop\zahlweg_verteilung_von_160401_bis_170207 - Kopie.csv' | sort bnr -Descending
$datei1_sort= Export-Csv -Path $datei1+sort -NoTypeInformation
$datei2_sort= Export-Csv -Path $datei2+sort -NoTypeInformation

$datei1 | Export-Csv -Path 'C:\Users\lukaskotowicz.BUR-KG\Desktop\zahlweg_verteilung_von_160401_bis_170207_sort.csv' -NoTypeInformation
$datei2 | Export-Csv -Path 'C:\Users\lukaskotowicz.BUR-KG\Desktop\zahlweg_verteilung_von_160401_bis_170207 - Kopie_sort.csv' -NoTypeInformation

