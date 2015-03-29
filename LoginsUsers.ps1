    #Import SQLPS Module
    Import-Module SQLPS -DisableNameChecking


    #Create server object, set name from variables
    #$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance


    $managedComputer = New-Object 'Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer' $instanceName


    #list services

$managedComputer.Services |
Select Name, ServiceAccount, DisplayName, ServiceState |
Format-Table -AutoSize