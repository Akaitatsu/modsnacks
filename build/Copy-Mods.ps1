param (
    [Parameter(Mandatory=$True)]$InstanceObject,
    [Parameter(Mandatory=$True)]$InstanceMods,
    [Parameter(Mandatory=$True)][string]$MinecraftPath
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
# Prep mods folder
$targetModsPath = "$MinecraftPath\mods\"
Remove-Item ($targetModsPath + "*.jar")
# Prep config folder
$targetConfigPath = "$MinecraftPath\config\"
Remove-Item ($targetConfigPath + "*") -Recurse
Get-ChildItem $targetConfigPath -Directory | Remove-Item -Force -Confirm:$false
# Copy mods and configs
Copy-ModsInList $InstanceMods $targetModsPath $targetConfigPath
Write-Host "  Copied Mods"