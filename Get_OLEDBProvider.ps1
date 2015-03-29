#Get_OLEDBProvider
#Remote to server

Enter-PSSession -ComputerName M031.nj1.mathematica.net 

(New-Object system.data.oledb.oledbenumerator).GetElements() | select SOURCES_NAME, SOURCES_DESCRIPTION | Sort-Object -Property Sources_Name | Format-Table -Autosize

#Export-Csv c:\Powershell\csv\M031_OLEDB.txt 

Exit-PSSession
