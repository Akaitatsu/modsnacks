# Verify that all the mods defined in the instance configuration have been downloaded to the modcache folder
function Test-ModCache {
    param (
        [Parameter(Mandatory=$True)]$allInstances
    )
    $modcachePath = "..\modcache\"
    $totalModCount = 0
    $foundModCount = 0
    foreach ($instance in $allInstances) {
        foreach ($mod in $instance.mods) {
            $modFilename = $mod.filenamePattern.Replace("%ver%", $mod.currentVersion) + ".jar"
            $modPath = ($modcachePath + $modFilename)
            $totalModCount++
            if (Test-Path $modPath) {
                $foundModCount++
            }
            else {
                Write-Host ("  Missing {0} for {1}" -f $modFilename, $instance.name)
            }
        }
    }
    return ($foundModCount -eq $totalModCount)
}