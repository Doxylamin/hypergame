$Global:VDD

Function GetVDDState {
    $Global:VDD = Get-PnpDevice | Where-Object { $_.friendlyname -like "Parsec Virtual Display Adapter" }
}

While (1 -gt 0) {
    GetVDDSTate
    If ($NULL -eq $Global:VDD) {
        Exit
    }
    Do {
        Enable-PnpDevice -InstanceId $Global:VDD.InstanceId -Confirm:$false
        Start-Sleep -s 5
        GetVDDState
    }
    Until ($Global:VDD.Status -eq 'OK')
    Start-Sleep -s 10
}
