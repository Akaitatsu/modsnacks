function New-JeiHideItemScript {
    param (
        [string[]]$modList,
        [string]$kubejsStartupPath
    )

    $jeiHideScriptPath = "$kubejsStartupPath\jeihideitems.js"
    $configData = Get-JsonAsPSCustomObject -Path "$PSScriptRoot\..\..\packdata\dynamicconfig\duplicateitemhandling.json" | Where-Object { $modList.Contains($_.modid) }

    # Write script header
    "//priority: 100" | Out-File $jeiHideScriptPath -Encoding ascii
    "events.listen('jei.hide.items', function (event) {" | Out-File $jeiHideScriptPath -Encoding ascii -Append

    foreach ($modGroup in $configData) {
        $itemsToHide = $modGroup.items | Where-Object -Property action -EQ -Value remove
        foreach ($itemToHide in $itemsToHide) {
            "      event.hide('$($modGroup.modid):$($itemToHide.itemid)') // $($itemToHide.comment)" | Out-File $jeiHideScriptPath -Encoding ascii -Append
        }
    }

    # Write script footer
    "})" | Out-File $jeiHideScriptPath -Encoding ascii -Append
}