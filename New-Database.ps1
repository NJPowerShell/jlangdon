#New-Database

function New-Database {
    Param(
          [Parameter(Mandatory=$true)][string]$instance, 
          [Parameter(Mandatory=$true)][string]$dbname,
          [Parameter(Mandatory=$true)][double]$datafilegrowth,
          [Parameter(Mandatory=$true)][double]$datafilesize,
          [Parameter(Mandatory=$true)][double]$logfilegrowth,
          [Parameter(Mandatory=$true)][double]$logfilesize 
       )
    #Import SQLPS Module
    Import-Module SQLPS -DisableNameChecking

    #Create server object, set name from variables
    $server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instance

    #Trim white space
    $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server, $dbName.Trim())
    $db.Create()
    $db.setowner('sa', $true)
    $db.alter()

    #Set data file properties
    foreach($group in $db.FileGroups)
        {
        $files = $group.files
            foreach($file in $files)
            {
                $filename = $file.filename
                $type = $file.growthtype
                $growth = $file.growth
                $size = $file.size
                $file.growthtype = “KB”
                $file.growth = $datafilegrowth 
                $file.size = $datafilesize 
                $file.alter()
            }
        }

   # Set log file properties
        $logfiles = $db.logfiles
            foreach($logfile in $logfiles)
            {
                $filename = $logfile.filename
                $growthtype = $logfile.growthtype
                $growth = $logfile.growth
                $size = $logfile.size  
                $logfile.growthtype = “KB”
                $logfile.growth = $logfilegrowth
                $logfile.size = $logfilesize
                $logfile.alter()
            }

}

