<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2014 v4.1.75
	 Created on:   	1/9/2015 6:17 PM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Database permissions functions
#>


function Add-WinDBUserWithRead
{
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$Winlogin,
		[Parameter(Mandatory = $true)][string]$dbname
	)
	#Return results
	$Results = ""
	#Get Server/Instance object
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	
	#Check if login exists
	$login = $server.Logins[$Winlogin]
	if ($login -eq $null)
	#if ($server.Logins.Contains($Winlogin))
	#if ($logins -notcontains $Winlogin)
	{
		Add-SqlLogin -sqlserver $server -name $Winlogin -logintype "WindowsUser" -DefaultDatabase 'master'
		$Results = "Login added,"
	}
	else
	{
		$Results = "Login exists,"
	}
	#Set login to dbuser for clarity even though they are on in the same
	$dbuser = $Winlogin
	
	#Get database object. Check if dbuser exists
	$db = $server.Databases[$dbname]
	if ($db.Users[$dbuser] -eq $null)
	{
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		$Results += " user created, db_datareader role granted"
		
	}
	else
	{
		$db.Users[$dbuser].Drop()
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		$Results += " user created, db_datareader role granted"
		
	}
		Write-Host $Results
}


function Add-WinDBUserWith
{
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$Winlogin,
		[Parameter(Mandatory = $true)][string]$dbname
	)
	#Import SQLPS Module
	#Import-Module SQLPSX -DisableNameChecking
	#Return results
	$Results = ""
	#Get Server/Instance object
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	
	#Check if login exists
	$login = $server.Logins[$Winlogin]
	if ($login -eq $null)
	#if ($server.Logins.Contains($Winlogin))
	#if ($logins -notcontains $Winlogin)
	{
		Add-SqlLogin -sqlserver $server -name $Winlogin -logintype "WindowsUser" -DefaultDatabase 'master'
		$Results = "Login added,"
	}
	else
	{
		$Results = "Login exists,"
	}
	#Set login to dbuser for clarity even though they are on in the same
	$dbuser = $Winlogin
	
	#Get database object. Check if dbuser exists
	$db = $server.Databases[$dbname]
	if ($db.Users[$dbuser] -eq $null)
	{
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		$Results += " user created, db_datareader and db_datawrite roles granted"
		
	}
	else
	{
		$db.Users[$dbuser].Drop()
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datawriter"
				$Results += " user created, db_datareader and db_datawrite roles granted"
		
	}
	Write-Host $Results
}

function Add-WinDBUser
{
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$Winlogin,
		[Parameter(Mandatory = $true)][string]$dbname
	)
	#Return results
	$Results = ""
	#Get Server/Instance object
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	
	#Check if login exists
	$login = $server.Logins[$Winlogin]
	if ($login -eq $null)
	#if ($server.Logins.Contains($Winlogin))
	#if ($logins -notcontains $Winlogin)
	{
		Add-SqlLogin -sqlserver $server -name $Winlogin -logintype "WindowsUser" -DefaultDatabase 'master'
		$Results = "Login added,"
	}
	else
	{
		$Results = "Login exists,"
	}
	#Set login to dbuser for clarity even though they are on in the same
	$dbuser = $Winlogin
	#Get database object. Check if dbuser exists
	$db = $server.Databases[$dbname]
	if ($db.Users[$dbuser] -eq $null)
	{
		$db.Users[$dbuser].Drop()
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datawriter"
		$Results += " user created, db_datareader and db_datawrite roles granted"
	}
	else
	{
		$db.Users[$dbuser].Drop()
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datawriter"
		$Results += " user created, db_datareader and db_datawrite roles granted"
	}
	Write-Host $Results
}






function Add-WinDBUserWithReadWrite
{
	Param (
		[Parameter(Mandatory = $true)][string]$instance,
		[Parameter(Mandatory = $true)][string]$Winlogin,
		[Parameter(Mandatory = $true)][string]$dbname
	)
	#Import SQLPS Module
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
		$Results = "Login added,"
	}
	else
	{
		$Results = "Login exists,"
	}
	#Set login to dbuser for clarity even though they are on in the same
	$dbuser = $Winlogin
	
	#Get database object. Check if dbuser exists
	$db = $server.Databases[$dbname]
	if ($db.Users[$dbuser] -eq $null)
	{
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datawriter"
		$Results += " user created, db_datareader, db_datawriter roles granted"
		
	}
	else
	{
		#Remove-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		$db.Users[$dbuser].Drop()
		$db.Refresh()
		Add-SqlUser -sqlserver $server -login $Winlogin -dbname $db -name $dbuser -defaultSchema "dbo"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datareader"
		Add-SqlDatabaseRoleMember -sqlserver $server -dbname $db -name $dbuser -rolename "db_datawriter"
		$Results += " user created, db_datareader, db_datawriter roles role granted"
		
	}
	Write-Host $Results
}

Add-WinDBUserWithReadWrite -instance "JLANGDON\MSSQLSERVER2012" -Winlogin "Mathematica\ADeng" -dbname "JL"



