function Get-LatestSecurityLog {
    param(
        [string]$ComputerName
    )
    Get-EventLog -LogName Security -Newest 10 -ComputerName $ComputerName
}

Get-LatestSecurityLog -ComputerName NJ1SQL08DevA