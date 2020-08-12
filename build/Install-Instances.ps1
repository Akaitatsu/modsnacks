Clear-Host
Set-Location $PSScriptRoot
$instances = (Get-Content -Raw -Path ..\packdata\instances.json | ConvertFrom-Json)
foreach ($instance in $instances) {
    Write-Host ("{0} ({1}): {2} MB" -f $instance.name, $instance.shortName, $instance.maxMemoryMB)
}