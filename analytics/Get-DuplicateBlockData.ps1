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
$blockStats