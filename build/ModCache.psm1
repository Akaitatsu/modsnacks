Import-Module .\ModConfig.psm1 -Force

# Verify that all the mods defined in the instance configuration have been downloaded to the modcache folder
function Get-ModFilename {
    param ($modObject)
    return $modObject.filenamePattern.Replace("%ver%", $modObject.currentVersion) + ".jar"
}
function Get-ModFilePath {
    param ($modObject)
    return "..\modcache\" + (Get-ModFilename $modObject)
}
function Get-Mods {
    Push-Location
    Set-Location $PSScriptRoot
    return (Get-Content -Raw -Path ..\packdata\mods.json | ConvertFrom-Json)
    Pop-Location
}
function Test-ModCache {
    $totalModCount = 0
    $foundModCount = 0
    $mods = Get-Mods
    foreach ($mod in $mods) {
        if ($mod.filenamePattern -ne "NA") {
            $modFilename = Get-ModFilename $mod
            $modPath = Get-ModFilePath $mod
            $totalModCount++
            if (Test-Path $modPath) {
                $foundModCount++
            }
            else {
                Write-Host ("  Missing {0} for {1}" -f $modFilename, $instance.name)
            }
        }
    }
    return ($foundModCount -eq $totalModCount)
}
function Copy-ModFromCache {
    param (
        $modObject,
        [string]$destinationPath
    )
    if ($modObject.filenamePattern -ne "NA") {
        $sourcePath = Get-ModFilePath $modObject
        $destinationFilePath
        Copy-Item -Path $sourcePath -Destination $destinationPath    
    }
}
