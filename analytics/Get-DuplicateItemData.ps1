param (
    [Parameter()][ValidateSet('LCMS','WFMS','GWMS')][string]$InstanceShortName = "GWMS"
)
Push-Location
Set-Location $PSScriptRoot
Import-Module .\Analytics.psm1 -Force

$crafterDumperOutputPath = Get-CrafterDumperOutputPath $InstanceShortName

$itemDataPath = "$CrafterDumperOutputPath\item_stacks_*.csv"
if (-not (Test-Path $itemDataPath)) {
    Write-Host "No Block Stats files were found in dump path '$CrafterDumperOutputPath'." -ForegroundColor Red
    Exit 1
}
$items = Get-ChildItem $itemDataPath | Sort-Object LastWriteTime | Select-Object -last 1 | Get-Content | ConvertFrom-Csv
$duplicates = $items | Group-Object -Property "Display name" | Where-Object { $_.Count -gt 1 } | Sort-Object -Property "Name"
$duplicates

Pop-Location