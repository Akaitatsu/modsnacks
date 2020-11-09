function New-RandomPatchesConfig {
    param (
        [string]$ModSnackVersion,
        [PSCustomObject]$InstanceInfo,
        [string]$ConfigPath
    )

    $templatePath = "$PSScriptRoot\..\..\packdata\dynamicconfig\randompatches.toml"
    $newConfigPath = "$configPath\randompatches.toml"
    $templateContent = Get-Content $templatePath
    $PSDefaultParameterValues['Out-File:Encoding'] = 'ASCII'
    foreach ($currentLine in $templateContent) {
        switch ($currentLine.Trim()) {
            "# RandomPatches configuration" { $currentLine | Out-File $newConfigPath }
            "title = ""Minecraft* %s""" {
                $newLine = "`t`ttitle = ""Minecraft* %s: $($InstanceInfo.name) $ModSnackVersion"""
                $newLine | Out-File $newConfigPath -Append
            }
            "titleWithActivity = ""Minecraft* %s - %s""" {
                $newLine = "`t`ttitleWithActivity = ""Minecraft* %s - %s: $($InstanceInfo.name) $ModSnackVersion"""
                $newLine | Out-File $newConfigPath -Append
            }
            default { $currentLine | Out-File $newConfigPath -Append }
        }
    }
}