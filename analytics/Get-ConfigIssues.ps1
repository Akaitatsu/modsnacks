Set-Location $PSScriptRoot

Import-Module .\Analytics.psm1 -Force

$splitLogsDirectory = Get-SplitLogsDirectory
$forgeLogPath = "$splitLogsDirectory\forge.log"

$textStream = New-Object System.IO.StreamReader -Arg $forgeLogPath
while (-not ($textStream.EndOfStream)) {
    $line = $textStream.ReadLine()
    $entry = Convert-StringToLogEntry $line
    $configFileIssueRegEx = "Configuration file [C-Zc-z]:\\MultiMC\\instances\\GWMS\\\.minecraft\\config\\((\w+)\-\w+\.\w+) is not correct\. Correcting"
    if ($entry.Message -match $configFileIssueRegEx) {
        $configFilename = $Matches[1]
        $modId = $Matches[2]
        $configDataPath = "..\packdata\config\$modId"
        $defaultConfigsDataPath = "..\packdata\defaultconfigs\$modId"
        if (Test-Path $configDataPath) {
            Write-Host "Probable config issue with $configFilename ($configDataPath)" -ForegroundColor Red
        }
        elseif (Test-Path $defaultConfigsDataPath) {
            Write-Host "Probable config issue with $configFilename ($defaultConfigsDataPath)" -ForegroundColor Red
        }
        else {
            Write-Host "Possible config issue with $configFilename" -ForegroundColor Yellow
        }
    }
}
$textStream.Close()