Describe 'SQL Server Services' -Tag "Infrastucture" {     

    Context 'SQL Server service' {

        It 'Should be running' {
            (Get-Service 'MSSQLSERVER').Status | Should -Be 'Running'
        }
    }

    Context 'SQL Server Agent service' {

        It 'Should be stopped' {
            (Get-Service 'SQLSERVERAGENT').Status | Should -Be 'Stopped'
        }
    }
}