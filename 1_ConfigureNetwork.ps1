"Creating VM Network Adapter"
New-VMSwitch -Name "GameSwitch" -SwitchType Internal
$ifIndex = (Get-NetAdapter | Where-Object -FilterScript {$_.Name -eq "vEthernet (GameSwitch)"} | Select-Object ifIndex)

"Assigning Prefix to interface"
New-NetIPAddress -IPAddress 192.168.99.1 -PrefixLength 24 -InterfaceIndex $ifIndex

"Creating NAT Table"
New-NetNat -Name "GameNAT" -InternalIPInterfaceAddressPrefix 192.168.99.0/24