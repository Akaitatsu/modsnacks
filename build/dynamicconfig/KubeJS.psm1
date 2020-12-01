Import-Module $PSScriptRoot\..\Utilities.psm1 -Force
Import-Module $PSScriptRoot\Jei.psm1 -Force

function New-KubeJSDynamicScripts {
    param (
        [PSCustomObject]$instanceObject,
        [string[]]$modList,
        [string]$minecraftPath
    )
    $kubejsScriptPath = New-DirectoryStructure $minecraftPath "\kubejs\data\$($instanceObject.shortName)"
    New-JeiHideItemScript -modList $modList -kubejsScriptsPath $kubejsScriptPath
}