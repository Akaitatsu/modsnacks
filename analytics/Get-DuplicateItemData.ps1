param (
    [Parameter()][ValidateSet('LCMS','WFMS','GWMS')][string]$InstanceShortName = "GWMS"
)
Push-Location
Set-Location $PSScriptRoot
Import-Module .\Analytics.psm1 -Force

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
$duplicateItems | ConvertTo-Csv -NoTypeInformation | Out-File $duplicatesFilePath -Encoding ascii
#if (Test-Path $duplicatesFilePath) { Remove-Item $duplicatesFilePath -Force }
Pop-Location