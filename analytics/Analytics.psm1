function Get-SplitLogsDirectory {
    return "$PSScriptRoot\splitlogs"
}

function Convert-StringToLogEntry {
    param (
        [Parameter(Mandatory=$True)][string]$LogString
    )

    $regEx = "\[(\d{2}\w{3}\d{4} \d{2}:\d{2}:\d{2}\.\d{3})\] \[([^/]*)\/([^\]]*)\] (?:\[STDERR\/\]: )?(?:\[STDOUT\/\]: )?\[([^/]*)\/?([^\]]*)?\]: (.*)"

    if ($LogString -match $regEx) {
        return [PSCustomObject]@{
            TimeStamp = $Matches[1]
            ThreadName = $Matches[2]
            Severity = $Matches[3]
            ModName = $Matches[4]
            LogName = $Matches[5]
            Message = $Matches[6]
        }
    }
    else {
        Write-Host "Log string could not be parsed." -ForegroundColor Red
        Write-Host $LogString -ForegroundColor Red
        return $null
    }
}