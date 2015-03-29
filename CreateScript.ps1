#Creating script

#Instead of hardcoding values, parameterize the script

#I added the $ComputerName variable with a string data type 


Param(
      [string]$ComputerName  = (Read-Host "Computer Name to query")
)
    Get-EventLog -LogName Security -Newest 5 -ComputerName $ComputerName


#Test by typing this into the shell - make sure you are in the correct directory

#cd c:\powershell\prod
#dir

#.\CreateScript.ps1 -ComputerName NJ1SQL08DevA

#.\CreateScript.ps1 -ComputerName NJ1SQL08DevA | format-table -Autosize

#See that you can now get help info
#Get-Help .\CreateScript.ps1

#Show read-host option for variable input
#.\CreateScript.ps1

#region
    #This works, but everytime you want to run this script you have to navigate to this directory.
#endregion

