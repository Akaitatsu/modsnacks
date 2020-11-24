param (
    [Parameter(Mandatory=$True)][string]$CrafterDumperOutputPath
)
$itemDataPath = "$CrafterDumperOutputPath\item_stacks_*.csv"
if (-not (Test-Path $itemDataPath)) {
    Write-Host "No Block Stats files were found in dump path '$CrafterDumperOutputPath'." -ForegroundColor Red
    Exit 1
}
$items = Get-ChildItem $itemDataPath | Sort-Object LastWriteTime | Select-Object -last 1 | Get-Content | ConvertFrom-Csv
$duplicates = $items | Group-Object -Property "Display name" | Where-Object { $_.Count -gt 1 } | Sort-Object -Property "Name"
$duplicates