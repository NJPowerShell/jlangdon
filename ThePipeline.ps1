#The Pipeline

Get-Service | Select-Object name, DisplayName, status | Sort-Object name | Format-Table -AutoSize

Get-Verb  #Cmdlets should do one job and do it well

cls ; Get-Process | Get-Member #-membertype properties #What kind of objects is Get-Process sending

Get-Help Stop-Process -Full 

#Parameter are accepted first by ByValue and secondly ByPropertyName


Get-Help Get-ADComputer -name 'JLangdon'


# Filter left, format right. 



#Getting Started with PowerShell 3.0: The pipeline: deeper - http://channel9.msdn.com/series/GetStartedPowerShell3/05