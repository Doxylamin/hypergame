

Function Get-DesktopPC {
  $isDesktop = $true
  if (Get-WmiObject -Class win32_systemenclosure | Where-Object { $_.chassistypes -eq 9 -or $_.chassistypes -eq 10 -or $_.chassistypes -eq 14 }) {
    Write-Warning "The computer is a laptop. Laptop GPUs that are partitioned and assigned to a VM may not work with Parsec." 
    Write-Warning "Thunderbolt 3 or 4 dock based GPU's may work"
    $isDesktop = $false 
  }
  if (Get-WmiObject -Class win32_battery)
  { $isDesktop = $false }
  $isDesktop
}

Function Get-WindowsCompatibleOS {
  $build = Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
  if ($build.CurrentBuild -ge 19041 -and ($($build.editionid -like 'Professional*') -or $($build.editionid -like 'Enterprise*') -or $($build.editionid -like 'Education*'))) {
    Return $true
  }
  Else {
    Write-Warning "Only Windows 10 20H1 or Windows 11 (Pro or Enterprise) is supported"
    Return $false
  }
}


Function Get-HyperVEnabled {
  if (Get-WindowsOptionalFeature -Online | Where-Object FeatureName -Like 'Microsoft-Hyper-V-All') {
    Return $true
  }
  Else {
    Write-Warning "You need to enable virtualization on the motherboard and then add the Hyper-V Windows feature and reboot."
    Return $false
  }
}

Function Get-WSLEnabled {
  if ((wsl -l -v)[2].length -gt 1 ) {
    Write-Warning "WSL is enabled. This can interfere with GPU-P and generate an error 43 in the VM."
    Return $true
  }
  Else {
    Return $false
  }
}

Function Get-VMGpuPartitionAdapterFriendlyName {
  $Devices = (Get-WmiObject -Class "Msvm_PartitionableGpu" -ComputerName $env:COMPUTERNAME -Namespace "ROOT\virtualization\v2").name
  Foreach ($GPU in $Devices) {
    $GPUParse = $GPU.Split('#')[1]
    Get-WmiObject Win32_PNPSignedDriver | Where-Object { ($_.HardwareID -eq "PCI\$GPUParse") } | Select-Object DeviceName -ExpandProperty DeviceName
  }
}

If ((Get-DesktopPC) -and (Get-WindowsCompatibleOS) -and (Get-HyperVEnabled)) {
  "System is compatible. Printing a list of compatible GPUs..."
  "Copy the name of the GPU you want to share, or substitute with AUTO for autodetection."
  Get-VMGpuPartitionAdapterFriendlyName
  Read-Host -Prompt "Press enter to exit"
}
else {
  Read-Host -Prompt "Press enter to exit"
}
