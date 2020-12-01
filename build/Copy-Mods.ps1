param (
    [Parameter(Mandatory=$True)]$InstanceObject,
    [Parameter(Mandatory=$True)]$InstanceMods,
    [Parameter(Mandatory=$True)][string]$MinecraftPath,
    [Parameter(Mandatory=$True)][bool]$SkipClearConfigs
)
Import-Module .\ModCache.psm1 -Force
Import-Module .\Utilities.psm1 -Force

function Copy-ModsInList {
    param (
        $modsArray,
        [Parameter(Mandatory=$True)][string]$MinecraftPath,
        [Parameter(Mandatory=$True)][string]$destinationModsPath
    )
    $copiedCount = 0
    foreach ($mod in $modsArray) {
        Copy-ModFromCache $mod $destinationModsPath
        Copy-ModConfig $mod $MinecraftPath
        $copiedCount++
        Write-Progress -Activity "Copying Mods and Static Configs" -Status "Progress:" -PercentComplete (($copiedCount / $modsArray.Count) * 100)
    }
    Write-Progress -Activity "Copying Mods and Static Configs" -Status "Progress:" -Completed
}

Write-Host "  Copying Mods"
# Prep mods folder
$targetModsPath = New-DirectoryStructure -RootPath $MinecraftPath -RelativeDirectoryStructure "mods" -ClearContents
Remove-Item ($targetModsPath + "\*.jar")
# Prep config folder
if (-not $SkipClearConfigs) {
    New-DirectoryStructure -RootPath $MinecraftPath -RelativeDirectoryStructure "config" -ClearContents | Out-Null
    New-DirectoryStructure -RootPath $MinecraftPath -RelativeDirectoryStructure "defaultconfigs" -ClearContents | Out-Null
}
# Copy mods and configs
Copy-ModsInList $InstanceMods $MinecraftPath $targetModsPath
Write-Host "  Copied Mods"