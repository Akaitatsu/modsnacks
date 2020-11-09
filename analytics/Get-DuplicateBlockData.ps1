param (
    [Parameter(Mandatory=$True)][string]$TellMeDumpPath
)
if (-not (Test-Path $TellMeDumpPath)) {
    Write-Host "Dump path '$TellMeDumpPath' does not exist." -ForegroundColor Red
    Exit 1
}
$blockstatsPath = "$TellMeDumpPath\block_stats_*.csv"
if (-not (Test-Path $blockstatsPath)) {
    Write-Host "No Block Stats files were found in dump path '$TellMeDumpPath'." -ForegroundColor Red
    Exit 1
}
$blockStats = Get-ChildItem $blockstatsPath | Sort-Object LastWriteTime | Select-Object -last 1 | Get-Content | ConvertFrom-Csv
$duplicates = $blockStats | Group-Object -Property "Display name" | Where-Object { $_.Count -gt 1 } | Sort-Object -Property "Name"
foreach ($duplicate in $duplicates) {
    Write-Host $duplicate.Name -ForegroundColor Cyan
    foreach ($blockEntry in $duplicate.Group) {
        Write-Host "  $($blockEntry.PSObject.Properties['Registry name'].Value) ($($blockEntry.PSObject.Properties['Count'].Value))"
    }
}