param (
    [Parameter(Mandatory=$True)]$instanceObject,
    [Parameter(Mandatory=$True)]$allInstances
)
Import-Module .\ModCache.psm1 -Force

function Copy-ModsInList {
    param (
        $modsArray,
        [string]$destinationModsPath,
        [string]$destinationConfigPath
    )
    foreach ($mod in $modsArray) {
        Copy-ModFromCache $mod $destinationModsPath
        Copy-ModConfig $mod $destinationConfigPath
    }
}

Write-Host "  Copying Mods"
$minecraftPath = "..\..\MultiMC\instances\$($instanceObject.shortName)\.minecraft"
$targetModsPath = "$minecraftPath\mods\"
$targetConfigPath = "$minecraftPath\config\"
Remove-Item ($targetModsPath + "*.jar")
Remove-Item ($targetConfigPath + "*") -Recurse
Get-ChildItem $targetConfigPath -Directory | Remove-Item -Force -Confirm:$false
foreach ($currentInstance in $allInstances) {
    # Copy LCMS mods to current instance
    if ($currentInstance.shortName -eq "LCMS") {
        Copy-ModsInList $currentInstance.mods $targetModsPath $targetConfigPath
    }
    # If installing WFMS or GWMS, copy WFMS mods to current instance
    if ($currentInstance.shortName -eq "WFMS" -and ($instanceObject.shortName -eq "WFMS" -or $instanceObject.shortName -eq "GWMS")) {
        Copy-ModsInList $currentInstance.mods $targetModsPath $targetConfigPath
    }
    # If installing GWMS, copy GWMS mods to current instance
    if ($currentInstance.shortName -eq "GWMS" -and $instanceObject.shortName -eq "GWMS") {
        Copy-ModsInList $currentInstance.mods $targetModsPath $targetConfigPath
    }
}
Write-Host "  Copied Mods"