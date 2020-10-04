function Copy-ModConfig {
    param (
        $modObject,
        [string]$destinationPath
    )
    $sourceFolder = "..\packdata\config\$($modObject.modid)"
    $sourcePath = "$sourceFolder\*"
    if (Test-Path $sourceFolder -PathType Container) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse
    }
}
