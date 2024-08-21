Get-ScheduledTask | Format-Table Taskname, State, LastRunTime | Out-File "resultList.txt"

Get-ScheduledTask | ForEach-Object {
    $task = $_
    $actions = $task.Actions.Execute
    $hash = if (Test-Path $actions) {
        Get-FileHash -Algorithm SHA256 $actions | Select-Object -ExpandProperty Hash
    } else {
        "N/A"
    }
    [PSCustomObject]@{
        TaskName     = $task.TaskName
        State        = $task.State
        LastRunTime  = $task.LastRunTime
        FileHash     = $hash
    }
} | Export-Csv -Path "HashList.csv" -NoTypeInformation
