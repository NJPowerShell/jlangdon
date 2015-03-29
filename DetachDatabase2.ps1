﻿function Detach-Databases
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
		#if ($database.IsSystemObject -eq $False -and $database.name -notlike "ReportServer*")
		if ($database.name -like "DeltekTE")
			{
			    $database.UserAccess = "Single"
			    $server.KillAllProcesses($database.name)
			    $database.alter()
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

Detach-Databases -instance "SQL_AWS3P01"