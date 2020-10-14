function Get-JsonAsPSCustomObject {
    param ( [string]$Path )

    return (Get-Content -Raw -Path $Path | ConvertFrom-Json)
}

function Copy-PSCustomObject {
    param ( [PSCustomObject]$object )

    return ($object | ConvertTo-Json | ConvertFrom-Json )
}

function Test-AllModsInList {
    param (
        [string[]]$modsToCheck,
        [string[]]$modList
    )
$modsToCheck
    return ($(Compare-Object $modsToCheck $modList -IncludeEqual -ExcludeDifferent).Count -eq $modsToCheck.Count)
}

function New-DirectoryStructure {
    param (
        [string]$rootPath,
        [string]$relativeDirectoryStructure
    )
    $directoryStructureParts = $relativeDirectoryStructure.Split('\')
    $newPath = $rootPath
    if ($newPath.EndsWith('\')) { $newPath = $newPath.Substring(0, $newPath.Length) }
    foreach ($directory in $directoryStructureParts) {
        $newPath = "$newPath\$directory"
        if (-not (Test-Path $newPath)) { New-Item -Path $newPath -ItemType Directory | Out-Null }
    }
    return $newPath
}