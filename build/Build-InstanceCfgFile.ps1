param (
    [Parameter(Mandatory=$True)]$instanceObject    
)
$newConfigPath = "..\..\MultiMC\instances\$($instanceObject.shortName)\instance.cfg"
Write-Host "  Creating '$newConfigPath'"
# Parse instance.cfg from template to a dictionary
$instanceConfigItems = Get-Content ..\instancetemplate\instance.cfg
$configEntries = @{}
foreach ($item in $instanceConfigItems) {
    $splitItem = $item.Split("=")
    $configEntries.Add($splitItem[0], $splitItem[1])
}

# Replace value for MaxMemAlloc
$configEntries.Set_Item("MaxMemAlloc", $instanceObject.maxMemoryMB)
# Replace value for name
$configEntries.Set_Item("name", $instanceObject.name)

# Serialize dictionary to new instance.cfg
$newConfig = [System.Text.StringBuilder]::new()
foreach ($key in $configEntries.Keys) {
    $newConfig.AppendFormat("{0}={1}", $key, $configEntries[$key]) | Out-Null
    $newConfig.AppendLine() | Out-Null
}
$newConfig.ToString() | Out-File $newConfigPath -Force
Write-Host "  Created '$newConfigPath'"