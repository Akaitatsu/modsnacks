param (
    [Parameter(Mandatory=$True)][string]$configPath,
    [Parameter(Mandatory=$True)][string]$filename,
    [Parameter(Mandatory=$True)][string]$modId,
    [Parameter(Mandatory=$True)][string]$blockRegistryName,
    [Parameter(Mandatory=$True)][int]$maxHeight,
    [Parameter(Mandatory=$True)][int]$minHeight,
    [Parameter(Mandatory=$True)][int]$maxVeinSize,
    [Parameter(Mandatory=$True)][int]$minVeinSize,
    [Parameter(Mandatory=$True)][string]$indicationFlowerRegistryId
)

$templatePath = "$PSScriptRoot\lod_deposit_template.cfg"
$newConfigPath = "$configPath\adlods\Deposits\$filename.cfg"
$templateContent = Get-Content $templatePath
$section = ""

foreach ($currentLine in $templateContent) {
    switch ($currentLine.Trim()) {
        "# Configuration file" { $currentLine | Out-File $newConfigPath }
        "S:ores <" {
            $currentLine | Out-File $newConfigPath -Append
            "		$($modId):$blockRegistryName" | Out-File $newConfigPath -Append
        }
        "Altitude {" { $section = "altitude" }
        "Size {" { $section = "size" }
        "I:max=" {
            switch ($section) {
                "altitude" { "$currentLine$maxHeight" | Out-File $newConfigPath -Append }
                "size" { "$currentLine$maxVeinSize" | Out-File $newConfigPath -Append }
                default { throw "Unrecognized config file section: $section" }
            }
        }
        "I:min=" {
            switch ($section) {
                "altitude" { "$currentLine$minHeight" | Out-File $newConfigPath -Append }
                "size" { "$currentLine$minVeinSize" | Out-File $newConfigPath -Append }
                default { throw "Unrecognized config file section: $section" }
            }
        }
        "S:circles <" {
            $currentLine | Out-File $newConfigPath -Append
            "			$indicationFlowerRegistryId, 3" | Out-File $newConfigPath -Append
            "			$indicationFlowerRegistryId, 6" | Out-File $newConfigPath -Append
        }
        default { $currentLine | Out-File $newConfigPath -Append }
    }
}