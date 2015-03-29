function Get-SystemInfo {
[CmdletBinding()]
param(
[Parameter(Mandatory=$True)][string]$computerName
)
$os = Get-WmiObject –Class Win32_OperatingSystem –Comp $computerName
$cs = Get-WmiObject –Class Win32_ComputerSystem –Comp $computerName
$props = @{'OSVersion'=$os.version;
'Model'=$cs.model;
'Manufacturer'=$cs.manufacturer;
'ComputerName'=$os.__SERVER;
'OSArchitecture'=$os.osarchitecture}
$obj = New-Object –TypeName PSObject –Property $props
Write-Output $obj
}



