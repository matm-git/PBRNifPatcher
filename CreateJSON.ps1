
# Ordnerpfad festlegen
# Liste für die JSON-Ausgabe initialisieren
$jsonList = @()
$currentPath = Get-Location
$outputFilePath = "$currentPath\PBR.json"
Write-Host $outputFilePath


# Alle Dateien mit dem Namensmuster *_n.dds finden
#Get-ChildItem -Path $folderPath -Filter "*_n.dds" | ForEach-Object {
Get-ChildItem -Filter "*_n.dds" -Recurse | ForEach-Object {
    # Ursprünglichen Dateinamen ohne _n.dds extrahieren
    $fileName = $_.BaseName -replace '_n$',''
    
    # JSON-Objekt erstellen und der Liste hinzufügen
    $jsonList += @{
        texture = $fileName
        emissive = $false
        parallax = $true
        subsurface_foliage = $false
        subsurface = $false
        specular_level = 0.04
        subsurface_color = @(1, 1, 1)
        roughness_scale = 1
        subsurface_opacity = 1
        smooth_angle = 75
        displacement_scale = 1.0
    }
}

# Überprüfen, ob die Datei existiert, und ggf. löschen
if (Test-Path $outputFilePath) {
    Remove-Item $outputFilePath
}


# Gesamte Liste in eine JSON-Datei ausgeben
#$jsonList | ConvertTo-Json -Compress | Out-File -FilePath "PBR.json" -Encoding UTF8


# Die Datei erstellen und den ersten Eintrag schreiben
$_firstEntry = $jsonList[0] | ConvertTo-Json -Compress
Set-Content -LiteralPath "$outputFilePath" -Value "[ `n"


# Für die restlichen Einträge, Zeilenumbruch und dann Append (Anhängen) verwenden
for ($i = 0; $i -lt $jsonList.Count; $i++) {
    Add-Content -LiteralPath $outputFilePath -Value ($jsonList[$i] | ConvertTo-Json -Compress) 
    if ($i -lt $jsonList.Count -1 ) { Add-Content -LiteralPath $outputFilePath -Value "," }
    #Add-Content -LiteralPath $outputFilePath -Value "`n"  # Zeilenumbruch

}
Add-Content -LiteralPath "$outputFilePath" -Value "] "
Write-Host $outputFilePath
# Zur Kontrolle auf der Konsole ausgeben
$jsonList | ConvertTo-Json -Compress


