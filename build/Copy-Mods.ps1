param (
    [Parameter(Mandatory=$True)]$instanceObject,
    [Parameter(Mandatory=$True)]$allInstances
)
Import-Module .\ModCache.psm1 -Force

function Copy-ModsInList {
    param (
        $modsArray,
        [string]$destinationPath
    )
    foreach ($mod in $modsArray) {
        Copy-ModFromCache $mod $destinationPath
    }
}

Write-Host "  Copying Mods"
$targetModsPath = "..\..\MultiMC\instances\$($instanceObject.shortName)\.minecraft\mods\"
Remove-Item ($targetModsPath + "*.jar")
foreach ($currentInstance in $allInstances) {
    # Copy LCMS mods to current instance
    if ($currentInstance.shortName -eq "LCMS") {
        Copy-ModsInList $currentInstance.mods $targetModsPath
    }
    # If installing WFMS or GWMS, copy WFMS mods to current instance
    if ($currentInstance.shortName -eq "WFMS" -and ($instanceObject.shortName -eq "WFMS" -or $instanceObject.shortName -eq "GWMS")) {
        Copy-ModsInList $currentInstance.mods $targetModsPath
    }
    # If installing GWMS, copy GWMS mods to current instance
    if ($currentInstance.shortName -eq "GWMS" -and $instanceObject.shortName -eq "GWMS") {
        Copy-ModsInList $currentInstance.mods $targetModsPath
    }
}
Write-Host "  Copied Mods"