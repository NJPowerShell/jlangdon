#region Presentation Prep

#Safety net in case F5 is mistakenly used instead of F8

#Set PowerShell ISE Zoom to 100%
$psISE.Options.Zoom = 150

#Show the OS version of demo maching
(Get-CimInstance -ClassName Win32_OperatingSystem).Caption

#Show the PowerShell version and build number
$PSVersionTable  #CLRVersion is .Net Framework. 

#Clear the screen
#Clear-Host

break 

#endregion

#Understanding Modules
<#Windows PowerShell 2.0 introduced the concept of modules. A module is a package that
can contain Windows PowerShell cmdlets, aliases, functions, variables, and even providers.#>

<#There are three default locations for Windows PowerShell modules. The first location is in
the users’ home directory, and the second is in the Windows PowerShell home directory.
The third default location, introduced in Windows PowerShell 4.0, is in the Program Files
\WindowsPowerShell\Modules directory. The advantage of this new location is that you do not
 need admin rights to install (such as in the System32 location), and it is not user specific.#>

 #Environment Variable - Modules locations 
 $env:PSModulePath.split(";")

 Get-Module  #Modules loaded
 
 Get-Module -ListAvailable  #Modules avaiable

 #Get-EventLog -LogName Security -Newest 10 -ComputerName NJ1SQL08DevA
 
  
