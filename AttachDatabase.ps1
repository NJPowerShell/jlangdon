<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.78
	 Created on:   	2/12/2015 2:07 PM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		The script will attach all User databases from a csv file.
#>

function Attach-Databases
{
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory = $true)][string]$instance
	)
	#Import SQLPS Module
	Import-Module SQLPS -DisableNameChecking
	#Create server object, set name from variables
	$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance
	
	#Start attach by getting database names from csv file
	$ImportedDBS = Get-Content -Path c:\Powershell\Text\detached.csv -Delimiter ","
	foreach ($dt in $ImportedDBS)
	{
		$db = ""
		if ($dt.contains(“,”))
		{
			$db = $dt.Replace(",", "")
		}
		else
		{
			$db = [string]$dt.trim()
		}
		Set-Location c:
		$owner = "sa"
		$mdfpath = "\\M034\O`$\Data\"
		$mdf = Get-ChildItem -LiteralPath $mdfpath -Filter $db*.mdf
		
		$ldfpath = "\\M034\O`$\Log\"
		$ldf = Get-ChildItem -LiteralPath $ldfpath -Filter $db*.ldf
		
		$datastr = "O:\Data\" + $mdf.Name
		$logstr = "O:\Log\" + $ldf.Name
		
		$sc = New-Object System.Collections.Specialized.StringCollection
		$sc.Add($datastr)
		$sc.Add($logstr)
		try
		{
			$server.AttachDatabase($db, $sc, $owner, [Microsoft.SqlServer.Management.Smo.AttachOptions]::None)
		}
		catch
		{
			Write-Host "Exception: $($_.Exception)"
			throw $_.Exception
		}
		Write-Host $sc
		Set-Location c:
	}
}


Attach-Databases -instance "SQL_AWS3P01"






