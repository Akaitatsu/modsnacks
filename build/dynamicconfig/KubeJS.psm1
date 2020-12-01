Import-Module $PSScriptRoot\..\Utilities.psm1 -Force
Import-Module $PSScriptRoot\Jei.psm1 -Force

function New-KubeJSDynamicScripts {
    param (
        [PSCustomObject]$instanceObject,
        [string[]]$modList,
        [string]$minecraftPath
    )
    $kubejsScriptPath = New-DirectoryStructure $minecraftPath "kubejs" -ClearContents
    $kubejsStartupPath = New-DirectoryStructure $kubejsScriptPath "startup"
    $kubejsModSnackPath = New-DirectoryStructure $kubejsScriptPath "data\$($instanceObject.shortName)"
    New-JeiHideItemScript -modList $modList -kubejsStartupPath $kubejsStartupPath
}