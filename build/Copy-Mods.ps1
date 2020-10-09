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
$instanceMods = Get-Mods | Where-Object { $instanceObject.includeInstanceMods.Contains($_.firstInstance) }
Copy-ModsInList $instanceMods $targetModsPath $targetConfigPath
Write-Host "  Copied Mods"