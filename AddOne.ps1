<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2015 v4.2.78
	 Created on:   	2/11/2015 3:20 PM
	 Created by:   	JLangdon
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
Function AddOne($int)
{
	$int + 1
}

$number = AddOne(5)
$number | get-member
'Display the value of $number: ' + $number


Function AddOne($int)
{
	Write-Host $int + 1
}

$number = AddOne(5)
$number | get-member
'Display the value of $number: ' + $number


Function AddOne($int)
{
	$number = $int + 1
}

$number = AddOne(5)
$number | get-member
'Display the value of $number: ' + $number

