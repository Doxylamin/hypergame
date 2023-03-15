Param (
    [string] $NetNatName,
    [string] $InternalIPAddress,
    [int] $InternalPort,
    [int] $ExternalPort,
    [int] $Range,
    [string] $Protocol
)

"Previous State was running so starting VM..."

for ($i = 0; $i -le $Range;  $i++) {
    $IntPort = $InternalPort + $i;
    $ExtPort = $ExternalPort + $i;
    "Creating mapping for $InternalIPAddress : $IntPort <=> 0.0.0.0 : $ExtPort"
    Add-NetNatStaticMapping -NatName $NetNatName -Protocol $Protocol -ExternalIPAddress 0.0.0.0 -ExternalPort $ExtPort -InternalIPAddress $InternalIPAddress -InternalPort $IntPort
}