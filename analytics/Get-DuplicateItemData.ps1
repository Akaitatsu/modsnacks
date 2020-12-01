param (
    [Parameter()][ValidateSet('LCMS','WFMS','GWMS')][string]$InstanceShortName = "GWMS"
)
Push-Location
Set-Location $PSScriptRoot
Import-Module .\Analytics.psm1 -Force
Import-Module ..\build\Utilities.psm1 -Force

$crafterDumperOutputPath = Get-CrafterDumperOutputPath $InstanceShortName
$workingDirectory = Get-AnalyticsWorkingDirectory
$duplicatesFilePath = "$workingDirectory\duplicates.csv"

$itemDataPath = "$CrafterDumperOutputPath\item_stacks_*.csv"
if (-not (Test-Path $itemDataPath)) {
    Write-Host "No Block Stats files were found in dump path '$CrafterDumperOutputPath'." -ForegroundColor Red
    Exit 1
}
$items = Get-ChildItem $itemDataPath -Exclude "item_stacks_*_amounts.csv" | Sort-Object LastWriteTime | Select-Object -last 1 | Get-Content -Raw | ConvertFrom-Csv
$duplicateGroups = $items | Group-Object -Property "Display Name" | Where-Object { $_.Count -gt 1 } | Sort-Object -Property "Name"
$items = $null
[System.Collections.ArrayList]$duplicateItems = @()
"Display Name,Mod ID,Item ID" | Out-File $duplicatesFilePath -Encoding ascii
foreach ($duplicateItem in $duplicateGroups) {
    foreach ($itemStack in $duplicateItem.Group) {
        $idParts = $itemStack.ID.Split(":")
        $duplicateItems.Add(
            [PSCustomObject] @{
            DisplayName = $itemStack."Display Name"
            ModID = $idParts[0]
            ItemID = $idParts[1]
        }) | Out-Null
    }
}
$duplicateGroups = $null
$startCount = $duplicateItems.Count
Write-Host ("Found {0:n0} duplicate items based on Display Name." -f $startCount) -ForegroundColor Cyan
# Remove duplicates where all the items belong to the same mod
$duplicateGroups = $duplicateItems | Group-Object -Property DisplayName
[Collections.Generic.List[string]]$itemsToDelete = @()
foreach ($duplicateItem in $duplicateGroups) {
    if (($duplicateItem.Group | Group-Object -Property ModID).Name.Count -eq 1) {
        $itemsToDelete.Add($duplicateItem.Group[0].DisplayName) | Out-Null
    }
}
for ($i = $duplicateItems.Count - 1; $i -ge 0; $i--) {
    if ($itemsToDelete.Contains($duplicateItems[$i].DisplayName)) {
        $duplicateItems.RemoveAt($i)
    }
}
Write-Host ("Removed {0:n0} duplicates where all items were in the same mod." -f ($startCount - $duplicateItems.Count)) -ForegroundColor Cyan
$startCount = $duplicateItems.Count
# Remove duplicates accounted for in configuration
$duplicateItemHandling = Get-JsonAsPSCustomObject "..\packdata\dynamicconfig\duplicateitemhandling.json"
foreach ($modHandler in $duplicateItemHandling) {
    foreach ($itemHandler in $modHandler.items) {
        #$handledItems = $duplicateItems | Where-Object {$_.ModID -eq $itemHandler.modid -and $_.ItemID -eq $itemHandler.itemid}
        $handledItems = $duplicateItems.Where( {($_.ModID -eq $modHandler.modid) -and ($_.ItemID -eq $itemHandler.itemid)} )
        foreach ($handledItem in $handledItems) {
            $duplicateItems.Remove($handledItem)
        }
    }
}
Write-Host ("Removed {0:n0} duplicates that are handled in the pack configuration." -f ($startCount - $duplicateItems.Count)) -ForegroundColor Cyan
$duplicateItems | ConvertTo-Csv -NoTypeInformation | Out-File $duplicatesFilePath -Encoding ascii
Write-Host ("{0:n0} duplicates remaining. See {1}" -f $duplicateItems.Count, $duplicatesFilePath) -ForegroundColor Cyan
#if (Test-Path $duplicatesFilePath) { Remove-Item $duplicatesFilePath -Force }
Pop-Location