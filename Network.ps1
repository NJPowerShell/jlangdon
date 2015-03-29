get-wmiobject win32_networkadapter | select netconnectionid, name, InterfaceIndex, netconnectionstatus


get-wmiobject win32_networkadapter -filter "netconnectionstatus = 2" |

select netconnectionid, name, InterfaceIndex, netconnectionstatus

# *** Entry point to script ***

 

Get-CimInstance -Class win32_networkadapter -computer $computer |

Select-Object Name, @{LABEL="Status";

 EXPRESSION={Get-StatusFromValue $_.NetConnect ionStatus}}