param (
    [string]$craftTweakerRecipeListFilepath = "D:\MCModding\Mod Snacks\recipelist.txt",
    [string]$outputFilepath = ""
)
if (-not (Test-Path $craftTweakerRecipeListFilepath)) {
    Write-Host "File Not Found: $craftTweakerRecipeListFilepath"
    Exit 1
}
if ($outputFilepath -eq "") {
    $outputFilepath = [io.path]::GetDirectoryName($craftTweakerRecipeListFilepath) + "\" + [io.path]::GetFileNameWithoutExtension($craftTweakerRecipeListFilepath) + ".csv"
}
if (Test-Path $outputFilepath) {
    Remove-Item $outputFilepath -Force
}

$recipeList = Get-Content $craftTweakerRecipeListFilepath
"""Crafting Type"",""Recipe ID""" | Out-File -FilePath $outputFilepath
$craftingType = ""
foreach ($line in $recipeList) {
    if ($line.StartsWith("- ")) {
        """$craftingType"",""$($line.Remove(0, 2))"""  | Out-File -FilePath $outputFilepath -Append
    } else {
        $craftingType = $line
    }
}