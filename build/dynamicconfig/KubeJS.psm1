Import-Module $PSScriptRoot\..\Utilities.psm1 -Force
Import-Module $PSScriptRoot\Jei.psm1 -Force

function New-RecipeIngredientReplacementScript {
    param (
        [string[]]$ModList,
        [string]$KubejsStartupPath
    )

    $replacementScriptPath = "$KubejsStartupPath\replaceingredients.js"
    $configData = Get-JsonAsPSCustomObject -Path "$PSScriptRoot\..\..\packdata\dynamicconfig\duplicateitemhandling.json" | Where-Object { $modList.Contains($_.modid) }

    # Write script header
    "//priority: 200" | Out-File $replacementScriptPath -Encoding ascii
    "events.listen('recipes', event => {" | Out-File $replacementScriptPath -Encoding ascii -Append

    foreach ($modGroup in $configData) {
        $itemsToReplace = $modGroup.items | Where-Object -Property action -EQ -Value remove
        foreach ($itemToReplace in $itemsToReplace) {
            "    event.replaceInput({}, '$($modGroup.modid):$($itemToReplace.itemid)', '$($itemToReplace.replacement)')" `
                | Out-File $replacementScriptPath -Encoding ascii -Append
            "    event.replaceOutput({}, '$($modGroup.modid):$($itemToReplace.itemid)', '$($itemToReplace.replacement)')" `
                | Out-File $replacementScriptPath -Encoding ascii -Append
        }
    }

    # Write script footer
    "})" | Out-File $replacementScriptPath -Encoding ascii -Append
}

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
    New-RecipeIngredientReplacementScript -ModList $modList -KubejsStartupPath $kubejsStartupPath
}