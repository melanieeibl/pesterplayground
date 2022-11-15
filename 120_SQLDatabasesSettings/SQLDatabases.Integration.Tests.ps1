BeforeDiscovery {
    #Capture database details on our instance
    [string]$SQLInstance = '.'

    $Query = `
            "SELECT [name]
            , SUSER_SNAME(owner_sid) AS Owner
            , CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoClose')) AS AutoClose
            , CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoShrink')) AS AutoShrink
            , CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoCreateStatistics')) AS AutoCreateStatistics
            , CONVERT(varchar(10),DATABASEPROPERTYEX([Name] , 'IsAutoUpdateStatistics')) AS AutoUpdateStatistics
            FROM master.sys.databases where name NOT IN ('master','model','msdb','tempdb')"

    $Global:databases = Invoke-SQLCMD -ServerInstance $SQLInstance -Database 'master' -Query $Query
}

Describe "Database Settings on '$SQLInstance'" -Tag "Infrastucture" {
    BeforeAll {
        $Script:databases = $Global:databases
    }
    
    Context "is optional" {

        It "All databases should be owned by current user '$([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)'" {
            $Script:databases.Count | Should -BeGreaterThan 0

            foreach ($database in $Script:databases) {
                $Database.Owner | Should -Be $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
            }
        }

        It "All databases should have auto shrink disabled" {
            $Script:databases.Count | Should -BeGreaterThan 0

            foreach ($database in $Script:databases) {
                $Database.AutoShrink | Should -Be 0
            }
        }
    }
}
