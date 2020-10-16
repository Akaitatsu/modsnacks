Import-Module "$PSScriptRoot\..\Utilities.psm1" -Force

function New-CreateCrushingPlantConfig {
    param (
        [string[]]$modList,
        [string]$createRecipesPath
    )

    $crushingRecipesPath = New-DirectoryStructure $createRecipesPath "crushing"
    $configData = Get-JsonAsPSCustomObject -Path "$PSScriptRoot\..\..\packdata\dynamicconfig\create-crushing-plant.json"
    $template = Copy-PSCustomObject $configData.template
    foreach ($modGroup in $configData.modGroups) {
        if (Test-AllModsInList $modGroup.mods $modList) {
            # Generate recipe files
            foreach ($recipe in $modGroup.recipes) {
                # Create Recipe File
                $newRecipe = Copy-PSCustomObject $template
                $newRecipe.ingredients[0] = $recipe.inputRegistryName
                $newRecipe.results[0].item = $recipe.guaranteedOutputRegistryName
                $newRecipe.results[1].item = $recipe.bonusOutputRegistryName
                if ($null -ne $recipe.bonusOutputChance) { $newRecipe.results[1].chance = $recipe.bonusOutputChance }
                Out-JsonRaw -Content $newRecipe -FilePath "$crushingRecipesPath\$($recipe.name).json"
            }
        }
    }
}

function New-CreateConfig {
    param (
        [string[]]$modList,
        [string]$openloaderPath
    )
    if ($modList.Contains("create")) {
        $createRecipesPath = New-DirectoryStructure $openloaderPath "create\recipes"
        New-CreateCrushingPlantConfig $modList $createRecipesPath
    }
}