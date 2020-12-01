function New-JeiHideItemScript {
    param (
        [string[]]$modList,
        [string]$kubejsScriptsPath
    )

    $jeiHideScriptPath = "$kubejsScriptsPath\jeihideitems.js"
    $configData = Get-JsonAsPSCustomObject -Path "$PSScriptRoot\..\..\packdata\dynamicconfig\create-crushing-plant.json"
    # Write script header
    "//priority: 100" | Out-File $jeiHideScriptPath -Encoding ascii
    "events.listen('jei.hide.items', function (event) {" | Out-File $jeiHideScriptPath -Encoding ascii -Append

    # Write script footer
    "})" | Out-File $jeiHideScriptPath -Encoding ascii -Append
}