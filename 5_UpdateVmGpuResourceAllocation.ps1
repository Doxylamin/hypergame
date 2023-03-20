<# 
Contributed in https://github.com/jamesstringerparsec/Easy-GPU-PV/pull/117 by https://github.com/Sm0rezDev

If you are opening this file in Powershell ISE you should modify the params section like so...

Param (
    [string]$VMName = "NameofyourVM",
    [int]$GPUResourceAllocationPercentage = 50
)

#>

Param (
    [string]$VMName,
    [int]$GPUResourceAllocationPercentage
)

$VM = Get-VM -VMName $VMName

if (($VMName -AND $GPUResourceAllocationPercentage) -ne [string]$null) {
    If ($VM.state -eq "Running") {
        [bool]$state_was_running = $true
    }
    
    if ($VM.state -ne "Off") {
        "Attempting to shutdown VM..."
        Stop-VM -Name $VMName -Force
    } 
    
    While ($VM.State -ne "Off") {
        Start-Sleep -s 3
        "Waiting for VM shutdown..."
    }

    [float]$divider = [math]::round($(100 / $GPUResourceAllocationPercentage), 2)

    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionVRAM ([math]::round($(1000000000 / $divider))) -MaxPartitionVRAM ([math]::round($(1000000000 / $divider))) -OptimalPartitionVRAM ([math]::round($(1000000000 / $divider)))
    Set-VMGPUPartitionAdapter -VMName $VMName -MinPartitionEncode ([math]::round($(18446744073709551615 / $divider))) -MaxPartitionEncode ([math]::round($(18446744073709551615 / $divider))) -OptimalPartitionEncode ([math]::round($(18446744073709551615 / $divider)))
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionDecode ([math]::round($(1000000000 / $divider))) -MaxPartitionDecode ([math]::round($(1000000000 / $divider))) -OptimalPartitionDecode ([math]::round($(1000000000 / $divider)))
    Set-VMGpuPartitionAdapter -VMName $VMName -MinPartitionCompute ([math]::round($(1000000000 / $divider))) -MaxPartitionCompute ([math]::round($(1000000000 / $divider))) -OptimalPartitionCompute ([math]::round($(1000000000 / $divider)))

    If ($state_was_running) {
        "VM was running previously, starting VM..."
        Start-VM $VMName
    }

    "Done..."
}