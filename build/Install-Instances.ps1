Clear-Host
Set-Location $PSScriptRoot
$instances = (Get-Content -Raw -Path ..\packdata\instances.json | ConvertFrom-Json)
foreach ($instance in $instances) {
    Write-Host ("Installing Instance {0} ({1})" -f $instance.name, $instance.shortName)
    .\Build-InstanceCfgFile.ps1 -instanceObject $instance
    .\Copy-StaticInstanceFiles.ps1 -instanceObject $instance
    .\Copy-Mods.ps1 -instanceObject $instance
    Write-Host ("Installed Instance {0} ({1})" -f $instance.name, $instance.shortName)
    Write-Host ""
}