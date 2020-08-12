Set-Location $PSScriptRoot
$instances = @("LCMS", "WFMS", "GWMS")
foreach ($instance in $instances) {
    $targetPath = "..\..\MultiMC\instances\$instance\.minecraft\mods"
    Copy-Item -Path "..\modcache\*.jar" -Destination $targetPath
}