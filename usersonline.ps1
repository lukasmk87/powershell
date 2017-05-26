$useronline = (Get-ChildItem \\d3cold\bursystem\_Infrastruktur\temp).count
Write-Host "USER OK: $useronline Benutzer sind angemeldet|aktiv=$useronline;;;"