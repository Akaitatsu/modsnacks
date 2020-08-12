param (
    [Parameter(Mandatory=$True)]$instanceObject    
)
Write-Host "  Copying Mods"
$targetModsPath = "..\..\MultiMC\instances\$($instanceObject.shortName)\.minecraft\mods"
Copy-Item -Path "..\modcache\*.jar" -Destination $targetModsPath
Write-Host "  Copied Mods"