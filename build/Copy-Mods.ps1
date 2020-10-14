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
    $copiedCount = 0
    foreach ($mod in $modsArray) {
        Copy-ModFromCache $mod $destinationModsPath
        Copy-ModConfig $mod $destinationConfigPath
        $copiedCount++
        Write-Progress -Activity "Copying Mods and Static Configs" -Status "Progress:" -PercentComplete (($copiedCount / $modsArray.Count) * 100)
    }
    Write-Progress -Activity "Copying Mods and Static Configs" -Status "Progress:" -Completed
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