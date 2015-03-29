Import-Module “sqlps” -DisableNameChecking

$server = "nj1dbtemp2.mathematica.net"
$instanceName = "NJ1DBTEMP2\SQLDMADEV"

$instance = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instanceName

        $SQLCommand = @"
set nocount on
SELECT DB_NAME([database_id])AS [Database Name], 
        [file_id], name, physical_name, type_desc, state_desc, 
        CONVERT( bigint, size/128.0) AS [Total Size in MB]
FROM sys.master_files WITH (NOLOCK)
ORDER BY DB_NAME([database_id]) OPTION (RECOMPILE);
"@

    $Results = Invoke-Sql -server $instance -database master -sql $SQLCommand 
    $SQLDatabaseFilesInUse = $Results | 
    select @{Name="fullname";Expression={$_.physical_Name -replace "\\\\","\" <#SQL server allows \\ in paths and just uses it like \#> }}

    $SQLDatabaseAndLogFilesOnDisk = invoke-command -ComputerName $server -ScriptBlock { 
        $Filesystems = get-psdrive -PSProvider FileSystem
        Foreach ($FileSystem in $Filesystems) {
            Get-ChildItem $FileSystem.Root -Recurse -include *.mdf,*.ldf,*.ndf -File -ErrorAction SilentlyContinue | select fullname 
        }
    }

    $SQLDatabaseAndLogFilesOnDisk = $SQLDatabaseAndLogFilesOnDisk | 
    Where fullname -notlike "C:\windows\winsxs*" | 
    Where fullname -notlike "C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\Binn\*" |
    select fullname


    Compare-Object -ReferenceObject $SQLDatabaseFilesInUse -DifferenceObject $SQLDatabaseAndLogFilesOnDisk -Property FullName -IncludeEqual:$IncludeEqual | FT -AutoSize

