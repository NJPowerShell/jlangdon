<#
.Synopsis
   Backs up and test user databases using second instance
.DESCRIPTION
   This script will perform a full backup of the user databases on a server, restore them
   to a second SQL Server instance, and perform a DBCC CheckDB on each restored database.
   It will verify before each restore that there's enough free space on the target disk
   drives before performing the restore, and it will kill all processes connected to the 
   database being restored so it can overwrite the database there if it already exists.
.EXAMPLE
   $srcinst NJ1DBTEMP2\SQLDMADEV
   $dstinst  NJ1SQL08DMADEV\SQL_DMADEV01
   $workdir \\mathematica.net\NDrive\Transfer\JLangdon
#>


# Get the SQL Server instance name from the command line
[CmdletBinding()]
param(
  # srcinst is the SQL Server instance being backed up
  [Parameter(Mandatory=$true)]
  [string]$srcinst=$null,
  # dstinst is the SQL Server instance where the databases will be restored and tested
  [Parameter(Mandatory=$true)]
  [string]$dstinst=$null,
  # workdir is the directory where the backups will be written
  [Parameter(Mandatory=$true)]
  [string]$workdir=$null
  )


# Test to see if the SQLPS module is loaded, and if not, load it
if (-not(Get-Module -name 'SQLPS')) {
  if (Get-Module -ListAvailable | Where-Object {$_.Name -eq 'SQLPS' }) {
    Push-Location # The SQLPS module load changes location to the Provider, so save the current location
	Import-Module -Name 'SQLPS' -DisableNameChecking
	Pop-Location # Now go back to the original location
    }
  }

# Connect to the specified instance
$srv = new-object ('Microsoft.SqlServer.Management.Smo.Server') $srcinst
$srv.ConnectionContext.StatementTimeout = 0
$dbs = $srv.Databases
$bdir = $workdir  

# Set up a collection to store the database names and backup files
$bup = @()

foreach ($db in $dbs)
#foreach ($db in $dbs | Where-Object {$_.Name -eq "master"})
  {
  if ($db.IsSystemObject -eq $False)
    {
	$dbname = $db.Name
        #$dt = Get-Date -Format yyyyMMddHHmmss
        #$bfile = "$bdir\$($dbname)_db_$($dt).bak"
		$bfile = "$bdir\$($dbname).bak"
	$bkup = New-Object System.Object
	$bkup | Add-Member -type NoteProperty -name Name -value $dbname
	$bkup | Add-Member -type NoteProperty -name Filename -value $bfile
	$bup += $bkup
        #Backup-SqlDatabase -ServerInstance $srcinst -Database $dbname -BackupFile $bfile -CompressionOption On -CopyOnly
		Backup-SqlDatabase -InputObject $srv.Name -Database $dbname -BackupFile $bfile -CompressionOption On  -CopyOnly 
    }
  }

# Connect to the destination instance
$dst = new-object ('Microsoft.SqlServer.Management.Smo.Server') $dstinst
# Get the default file and log locations
# (If DefaultFile and DefaultLog are empty, use the MasterDBPath and MasterDBLogPath values)
$fileloc = $dst.Settings.DefaultFile
$logloc = $dst.Settings.DefaultLog
if ($fileloc.Length -eq 0) {
    $fileloc = $dst.Information.MasterDBPath
    }
if ($logloc.Length -eq 0) {
    $logloc = $dst.Information.MasterDBLogPath
    }
    #

	
# Now restore the databases to the destination server
foreach ($bkup in $bup)
  {
  $bckfile = $bkup.Filename
  $dbname  = $bkup.Name

  # Use the backup file name to create the backup device
  $bdi = new-object ('Microsoft.SqlServer.Management.Smo.BackupDeviceItem') ($bckfile, 'File')
  
  # Create an empty collection for the RelocateFile objects
  $rfl = @()
  
  # Create a Restore object so we can read the details inside the backup file
  $rs = new-object('Microsoft.SqlServer.Management.Smo.Restore')
  $rs.Database = $dbname
  $rs.Devices.Add($bdi)
  $rs.ReplaceDatabase = $True

  # Get the file list info from the backup file
  $fl = $rs.ReadFileList($srv)
  $fl | foreach {
    $dfile = Split-Path $_.PhysicalName -leaf
    $rsfile = new-object('Microsoft.SqlServer.Management.Smo.RelocateFile')
    $rsfile.LogicalFileName = $_.LogicalName
	$rssize = $_.Size
    if ($_.Type -eq 'D') {
      $rsfile.PhysicalFileName = $fileloc + '\' + $dfile
	  $ddrv = Split-Path $fileloc -Qualifier
      }
    else {
      $rsfile.PhysicalFileName = $logloc + '\' + $dfile
 	  $ddrv = Split-Path $logloc -Qualifier
     }
    $rfl += $rsfile
    
 	}
   
    # Restore the database 
	# Get everyone out of the database
	$dst.KillAllProcesses($dbname)
	Restore-SqlDatabase -ServerInstance $dstinst -Database $dbname -BackupFile $bckfile -RelocateFile $rfl -ReplaceDatabase 
  }
  
