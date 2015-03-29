
Import-Module "SQLPS" -DisableNameChecking

$ServerName = "SQL_ISDEV01"
$SQLSvr = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerName)

$Db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database
$Db = $SQLSvr.Databases.Item("master")
#$Db = $SQLSvr.Databases.Item("model")
#$Db = $SQLSvr.Databases.Item("msdb")



$Backup = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Backup
$Backup.Action = [Microsoft.SQLServer.Management.SMO.BackupActionType]::Database
$backup.BackupSetDescription = "Full Backup of "+$Db.Name
$Backup.Database = $db.Name

$BackupName = "\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\"+$Db.Name+"_"+".bak"
#$BackupName = "\\Mathematica.net\NDrive\Project\SQL__Transfer-SIS\Restricted\NJ1\"+$Db.Name+"_"+[DateTime]::Now.ToString("yyyyMMdd_HHmmss")+".bak"
$DeviceType = [Microsoft.SqlServer.Management.Smo.DeviceType]::File
$BackupDevice = New-Object -TypeName Microsoft.SQLServer.Management.Smo.BackupDeviceItem($BackupName,$DeviceType)

$Backup.Devices.Add($BackupDevice)
$Backup.SqlBackup($SQLSvr)
$Backup.Devices.Remove($BackupDevice)

#$dt = Get-Date -Format yyyyMMddHHmmss

#$svr = New-Object 'Microsoft.SqlServer.Management.SMO.Server' $inst
#$bdir = $svr.Settings.BackupDirectory