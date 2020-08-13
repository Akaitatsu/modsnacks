Clear-Host
Set-Location $PSScriptRoot
$instances = (Get-Content -Raw -Path ..\packdata\instances.json | ConvertFrom-Json)
Write-Host "Verifying Mod Cache"
Import-Module .\ModCache.psm1 -Force
if (-not (Test-ModCache $instances)) {
    Write-Host "Mod Cache Failed Verification; see messages above"
    Exit 1
}
Write-Host "Verified Mod Cache"
foreach ($instance in $instances) {
    Write-Host ("Installing Instance {0} ({1})" -f $instance.name, $instance.shortName)
    .\Build-InstanceCfgFile.ps1 -instanceObject $instance
    .\Copy-StaticInstanceFiles.ps1 -instanceObject $instance
    .\Copy-Mods.ps1 -instanceObject $instance
    Write-Host ("Installed Instance {0} ({1})" -f $instance.name, $instance.shortName)
    Write-Host ""
}