function Add-WinDBUserWithRead
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$Winlogin,
		[Parameter(Mandatory = $true)][string]$dbname
	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	#Return results
	$Results = ""
	#Get Server/Instance object
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	
	#Check if login exists
	if ($server.Logins[$Winlogin] -eq $null)
	#if ($server.Logins.Contains($Winlogin))
	#if ($logins -notcontains $Winlogin)
	{
		Add-SqlLogin -sqlserver $server -name $Winlogin -logintype "WindowsUser" -DefaultDatabase 'master'
	}
	else
	{
		$Results = "Login exists"
	}
	#Set login to dbuser for clarity even though they are on in the same
	$dbuser = $Winlogin
	
	#Get database object. Check if dbuser exists
	$db = $server.Databases[$dbname]
	if ($db.Users[$dbuser] -eq $null)
	{
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		$Results += " User created, db_datareader role granted"
		
	}
	else
	{
		$db.Users[$dbuser].Drop()
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		$Results += " User created, db_datareader role granted"
		
	}
}


function Get-LatestSecurityLog
{
	[CmdletBinding()]
	Param(
          [string]$ComputerName # = (Read-Host "Computer Name to query")
    )
    Get-EventLog -LogName Security -Newest 5 -ComputerName $ComputerName
}

#Get-LatestSecurityLog -ComputerName NJ1SQL08DevA

function Get-OSInfo {
    param(
        [string]$ComputerName
    )
    Get-CimInstance -ClassName Win32_Bios -ComputerName $ComputerName
}

function New-Database
{
	[CmdletBinding()]
	Param(
          [Parameter(Mandatory=$true)][string]$instance, 
          [Parameter(Mandatory=$true)][string]$dbname,
          [Parameter(Mandatory=$true)][double]$datafilegrowth,
          [Parameter(Mandatory=$true)][double]$datafilesize,
          [Parameter(Mandatory=$true)][double]$logfilegrowth,
          [Parameter(Mandatory=$true)][double]$logfilesize 
       )
    #Import SQLPS Module
    Import-Module SQLPS -DisableNameChecking
    #Create server object, set name from variables
    $server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
    #Trim white space
    $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server, $dbName.Trim())
    $db.Create()
    $db.setowner('sa', $true)
    $db.create()
    #Set data file properties
    foreach($group in $db.FileGroups)
        {
        $files = $group.files
            foreach($file in $files)
            {
                $filename = $file.filename
                $type = $file.growthtype
                $growth = $file.growth
                $size = $file.size
                $file.growthtype = “KB”
                $file.growth = $datafilegrowth 
                $file.size = $datafilesize 
                $file.alter()
            }
        }
   # Set log file properties
        $logfiles = $db.logfiles
            foreach($logfile in $logfiles)
            {
                $filename = $logfile.filename
                $growthtype = $logfile.growthtype
                $growth = $logfile.growth
                $size = $logfile.size  
                $logfile.growthtype = “KB”
                $logfile.growth = $logfilegrowth
                $logfile.size = $logfilesize
                $logfile.alter()
            }
}

function Detach-Databases
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$instance
	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	#Create server object, set name from variables
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	[System.Collections.ArrayList]$dbs = $server.databases
	[System.Collections.ArrayList]$DBsToDetach = @()
	[System.Collections.ArrayList]$Detached = @()
	
	#Set data file properties
	foreach ($database in $dbs)
	{
		if ($database.IsSystemObject -eq $False -and $database.name -notlike "ReportServer*")
		{
			$database.UserAccess = "Single"
			$database.Alter([Microsoft.SqlServer.Management.Smo.TerminationClause]"RollbackTransactionsImmediately")
			$DBsToDetach.Clear()
			$DBsToDetach.Add($database)
			
			foreach ($d in $DBsToDetach)
			{
				$server.DetachDatabase($database.Name, $false, $false)
				$Detached.Add($database.name)
			}
		}
	}
	$Detached -join "," >> c:\Powershell\Text\detached.csv
}
















#Call Get-OSInfo function
#Get-OSInfo -ComputerName NJ1SQL08DevA


#region Modules

#Understanding Modules

<#Windows PowerShell 2.0 introduced the concept of modules. A module is a package that
can contain Windows PowerShell cmdlets, aliases, functions, variables, and even providers.#>

<#There are three default locations for Windows PowerShell modules. The first location is in
the users’ home directory, and the second is in the Windows PowerShell home directory.
The third default location, introduced in Windows PowerShell 4.0, is in the Program Files
\WindowsPowerShell\Modules directory. The advantage of this new location is that you do not
 need admin rights to install (such as in the System32 location), and it is not user specific.#>

 #Environment Variable - Modules locations 
 #$env:PSModulePath.split(";")

 #Get-Module  #Modules loaded
 
 #Get-Module -ListAvailable  #Modules avaiable

 #Get-EventLog -LogName Security -Newest 10 -ComputerName NJ1SQL08DevA

 #endregion
 
  
