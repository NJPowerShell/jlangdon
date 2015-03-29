<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.81
	 Created on:   	3/17/2015 9:40 AM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
Get-Command -CommandType Cmdlet, Function

Get-Command -Module NetAdapter -Verb Get

$Command = Get-Command -Name Get-Process

$Command.Parameters

$Command.Parameters['Name'].Attributes | ForEach {
	
	Write-Verbose  $_.GetType().FullName -Verbose
	
	$_
	
}

Get-Command -ParameterName Computername

Get-Command -ParameterType [hashtable]


Get-Command -CommandType Cmdlet -ParameterType [hashtable] | ForEach {
	
	$Command = $_.Name
	
	$_.Parameters.GetEnumerator() | ForEach {
		
		$Parameter = $_.Key
		
		Switch ($_.value.ParameterType)
		{
			{ $_ -eq [hashtable] } {
				
				$Type = 'Hashtable'
				
			}