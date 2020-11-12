param (
    [bool]$SkipModCopy = $false,
    [bool]$SkipClearConfigs = $false
)
Set-Location $PSScriptRoot

Import-Module .\Utilities.psm1 -Force
Import-Module .\ModCache.psm1 -Force
Clear-Host

$modSnackInfo = Get-JsonAsPSCustomObject -Path ..\packdata\modsnacks.json
$instances = Get-JsonAsPSCustomObject -Path ..\packdata\instances.json
Write-Host "Verifying Mod Cache"
if (-not (Test-ModCache)) {
    Write-Host "Mod Cache Failed Verification; see messages above"
    Exit 1
}
Write-Host "Verified Mod Cache"
Import-Module .\dynamicconfig\Create.psm1 -Force
Import-Module .\dynamicconfig\Druidcraft.psm1 -Force
Import-Module .\dynamicconfig\RandomPatches.psm1 -Force
foreach ($instance in $instances) {
    Write-Host ("Installing Instance {0} ({1})" -f $instance.name, $instance.shortName)
    .\Build-InstanceCfgFile.ps1 -instanceObject $instance
    .\Copy-StaticInstanceFiles.ps1 -instanceObject $instance
    $instanceMods = Get-Mods | Where-Object { $instance.includeInstanceMods.Contains($_.firstInstance) }
    $minecraftPath = "..\..\MultiMC\instances\$($instance.shortName)\.minecraft"
    $configPath = "$minecraftPath\config"
    if (-not $SkipModCopy) {
        .\Copy-Mods.ps1 -InstanceObject $instance -InstanceMods $instanceMods -MinecraftPath $minecraftPath -SkipClearConfigs $SkipClearConfigs
    }
    Write-Host "  Generating dynamic configuration files"
    # Prep openloader folder
    $targetOpenLoaderPath = New-DirectoryStructure $minecraftPath "openloader\data"
    Remove-Item ($targetOpenLoaderPath + "\*") -Recurse
    $modList = $instanceMods.modid
    New-CreateConfig -modList $modList -openloaderPath $targetOpenLoaderPath
    New-DruidcraftConfig -modList $modList -openloaderPath $targetOpenLoaderPath
    New-RandomPatchesConfig -ModSnackVersion $modSnackInfo.modSnackVersion -InstanceInfo $instance -ConfigPath $configPath
    Write-Host "  Generated dynamic configuration files"
    Write-Host ("Installed Instance {0} ({1})" -f $instance.name, $instance.shortName)
    Write-Host ""
}