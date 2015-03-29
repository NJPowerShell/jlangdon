#Import SQLPS Module
Import-Module SQLPS -DisableNameChecking
[string]$instance = "SQL_ISDEV01"
#Create server object, set name from variables
$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
[System.Collections.ArrayList]$dbs = $server.databases
$dbs = "40233_SEC__Namibia". "aspnetdb"
$backupfolder = "C:\Backups\"

foreach ($database in $dbs)
{
	{
		$backupfile = "$($databasename)_Full_$($timestamp).bak"
		$fullBackupFile = Join-Path $backupfolder $backupfile
		Backup-SqlDatabase `
		-ServerInstance $instanceName `
		-Database $databasename `
		-BackupFile $fullBackupFile `
		-Checksum `
		-Initialize `
		-BackupSetName "$databasename Full Backup" `
		-CompressionOption On
		
	}
}








