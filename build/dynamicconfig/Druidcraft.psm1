Import-Module "$PSScriptRoot\..\Utilities.psm1" -Force

function New-DruidcraftWoodcuttingConfig {
    param (
        [string[]]$modList,
        [string]$druidcraftRecipesPath
    )

    $woodcuttingRecipesPath = New-DirectoryStructure $druidcraftRecipesPath "woodcutting"
    $configData = Get-JsonAsPSCustomObject -Path "$PSScriptRoot\..\..\packdata\dynamicconfig\druidcraft-woodcutting.json"
    $template = Copy-PSCustomObject $configData.template
    foreach ($modGroup in $configData.modGroups) {
        if (Test-AllModsInList $modGroup.mods $modList) {
            # Generate recipe files
            foreach ($recipe in $modGroup.recipes) {
                # Create Recipe File
                $newRecipe = Copy-PSCustomObject $template
                $newRecipe.ingredient.tag = $recipe.inputRegistryName
                $newRecipe.result = $recipe.outputRegistryName
                $outputType = $recipe.name.Substring($recipe.name.LastIndexOf("_") + 1)
                $newRecipe.count = $configData.outputCounts.PSObject.Properties[$outputType].Value
                #$newRecipe
                $newRecipe | ConvertTo-Json | Out-File -FilePath "$woodcuttingRecipesPath\$($recipe.name).json"
            }
        }
    }
}

function New-DruidcraftConfig {
    param (
        [string[]]$modList,
        [string]$openloaderPath
    )
    if ($modList.Contains("druidcraft")) {
        $druidcraftRecipesPath = New-DirectoryStructure $openloaderPath "druidcraft\recipes"
        New-DruidcraftWoodcuttingConfig $modList $druidcraftRecipesPath
    }
}