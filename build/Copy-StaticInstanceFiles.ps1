param (
    [Parameter(Mandatory=$True)]$instanceObject    
)
Write-Host "  Copying static instance files"
$targetInstancePath = "..\..\MultiMC\instances\$($instanceObject.shortName)\"
Copy-Item -Path "..\instancetemplate\mmc-pack.json" -Destination $targetInstancePath
Write-Host "  Copied static instance files"