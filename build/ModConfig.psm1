function New-LodDepositConfig {
    param (
        [string]$modId,
        $lodConfig,
        [string]$configPath
    )
    
    $templatePath = "$PSScriptRoot\configtemplates\lod_deposit_template.cfg"
    $filename = $lodConfig.blockRegistryName.Replace("_ore", "")
    $newConfigPath = "$configPath\adlods\Deposits\$filename.cfg"
    $templateContent = Get-Content $templatePath
    $section = ""
    
    foreach ($currentLine in $templateContent) {
        switch ($currentLine.Trim()) {
            "# Configuration file" { $currentLine | Out-File $newConfigPath }
            "S:ores <" {
                $currentLine | Out-File $newConfigPath -Append
                "		#$($modId):$($lodConfig.blockRegistryName)" | Out-File $newConfigPath -Append
            }
            "Altitude {" {
                $section = "altitude"
                $currentLine | Out-File $newConfigPath -Append
            }
            "Size {" {
                $section = "size"
                $currentLine | Out-File $newConfigPath -Append
            }
            "I:max=" {
                switch ($section) {
                    "altitude" { "$currentLine$($lodConfig.maxHeight)" | Out-File $newConfigPath -Append }
                    "size" { "$currentLine$($lodConfig.maxVeinSize)" | Out-File $newConfigPath -Append }
                    default { throw "Unrecognized config file section: $section" }
                }
            }
            "I:min=" {
                switch ($section) {
                    "altitude" { "$currentLine$($lodConfig.minHeight)" | Out-File $newConfigPath -Append }
                    "size" { "$currentLine$($lodConfig.minVeinSize)" | Out-File $newConfigPath -Append }
                    default { throw "Unrecognized config file section: $section" }
                }
            }
            "S:circles <" {
                $currentLine | Out-File $newConfigPath -Append
                "			$($lodConfig.indicationFlowerRegistryId), 3" | Out-File $newConfigPath -Append
                "			$($lodConfig.indicationFlowerRegistryId), 6" | Out-File $newConfigPath -Append
            }
            default { $currentLine | Out-File $newConfigPath -Append }
        }
    }
}

function New-LodDepositConfigsForMod {
    param (
        $modObject,
        [string]$configPath
    )

    if ($null -eq $modObject.largeOreDepositsConfig) {
        return
    }

    if (-not (Test-Path "$configPath\adlods")) {
        New-Item "$configPath\adlods" -ItemType Directory | Out-Null
    }
    if (-not (Test-Path "$configPath\adlods\Deposits")) {
        New-Item "$configPath\adlods\Deposits" -ItemType Directory | Out-Null
    }

    $modObject.largeOreDepositsConfig | ForEach-Object {
        New-LodDepositConfig $modObject.modid $_ $configPath
    }
}

function Copy-ModConfig {
    param (
        $modObject,
        [string]$destinationPath
    )
    # Copy mod config files
    $sourceFolder = "..\packdata\config\$($modObject.modid)"
    $sourcePath = "$sourceFolder\*"
    if (Test-Path $sourceFolder -PathType Container) {
        Copy-Item -Path $sourcePath -Destination $destinationPath -Recurse -Force | Out-Null
    }

    # Create deposit configs for Large Ore Deposits
    New-LodDepositConfigsForMod -modObject $modObject -configPath $destinationPath
}
